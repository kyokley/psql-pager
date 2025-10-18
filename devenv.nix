{ pkgs, lib, config, inputs, ... }:
{
  # https://devenv.sh/basics/
  env = {
    DOCKER_BUILD_ARGS = lib.mkDefault "";
  };

  # https://devenv.sh/packages/
  packages = [pkgs.docker];

  # https://devenv.sh/languages/
  languages = {
    python = {
      enable = true;
      version = "3.13";
      uv = {
        enable = true;
        sync.enable = true;
      };
    };
  };

  # https://devenv.sh/processes/
  # processes.dev.exec = "${lib.getExe pkgs.watchexec} -n -- ls -la";

  # https://devenv.sh/services/
  # services.postgres.enable = true;

  # https://devenv.sh/scripts/
  scripts = {
    _build.exec = ''
      docker build ''${DOCKER_BUILD_ARGS} -t kyokley/$@ --target=$@ .
    '';
    build-pgcli.exec = ''
      _build pgcli
    '';
    build-psql.exec = ''
      _build psql
    '';
    build-usql.exec = ''
      _build usql
    '';
    build.exec = ''
      build-pgcli
      build-psql
      build-usql
    '';
    publish.exec = ''
      build
      docker push kyokley/pgcli
      docker push kyokley/psql
      docker push kyokley/usql
    '';
    test-setup.exec = ''
      docker compose -f tests/docker-compose.yml up -d postgres
      sleep 1
      docker compose -f tests/docker-compose.yml exec -T postgres /bin/bash -c 'psql -U postgres -f /app/setup.sql'
    '';
    test-down.exec = ''
      docker compose -f tests/docker-compose.yml down -v --remove-orphans
    '';
    test-pgcli.exec = ''
      build-pgcli
      docker compose -f tests/docker-compose.yml run --entrypoint /bin/sh pgcli -c 'echo  "SELECT * FROM accounts;" | uv run pgcli -h postgres -U postgres'
    '';
    test-psql.exec = ''
      build-psql
      docker compose -f tests/docker-compose.yml up -d psql
      docker compose -f tests/docker-compose.yml run --entrypoint /bin/sh psql -c 'echo  "SELECT * FROM accounts;" | psql -h postgres -U postgres'
    '';
    test-usql.exec = ''
      build-usql
      docker compose -f tests/docker-compose.yml up -d usql
      docker compose -f tests/docker-compose.yml run --entrypoint /bin/sh usql -c 'echo  "SELECT * FROM accounts;" | usql postgres://postgres@postgres'
    '';
    tests.exec = ''
      set -e
      test-setup
      test-psql
      test-pgcli
      test-usql
      test-down
    '';
  };

  # https://devenv.sh/basics/
  enterShell = ''
      echo Welcome to
      ${pkgs.figlet}/bin/figlet -f slant 'PSQL Pager' | ${pkgs.lolcat}/bin/lolcat
      echo
  '';

  # https://devenv.sh/tasks/
  # tasks = {
  #   "myproj:setup".exec = "mytool build";
  #   "devenv:enterShell".after = [ "myproj:setup" ];
  # };

  # https://devenv.sh/tests/
  enterTest = ''
    tests
  '';

  # https://devenv.sh/git-hooks/
  # git-hooks.hooks.shellcheck.enable = true;

  # See full reference at https://devenv.sh/reference/options/
}
