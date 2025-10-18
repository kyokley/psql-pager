{ pkgs, lib, config, inputs, ... }:
{
  # https://devenv.sh/basics/
  env = {
    DOCKER_BUILD_ARGS = lib.mkDefault "";
  };

  # https://devenv.sh/packages/
  packages = [];

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
    build-pgcli.exec = ''
      docker build ''${DOCKER_BUILD_ARGS} -t kyokley/pgcli --target=pgcli .
    '';
    build-psql.exec = ''
      docker build ''${DOCKER_BUILD_ARGS} -t kyokley/psql --target=psql .
    '';
    build.exec = ''
      build-pgcli
      build-psql
    '';
    test-setup.exec = ''
      ${pkgs.docker}/bin/docker compose -f tests/docker-compose.yml up -d postgres
      sleep 1
      ${pkgs.docker}/bin/docker compose -f tests/docker-compose.yml exec -T postgres /bin/bash -c 'psql -U postgres -f /app/setup.sql'
    '';
    test-down.exec = ''
      ${pkgs.docker}/bin/docker compose -f tests/docker-compose.yml down -v
    '';
    test-pgcli.exec = ''
      build-pgcli
      ${pkgs.docker}/bin/docker compose -f tests/docker-compose.yml up -d pgcli
      ${pkgs.docker}/bin/docker compose -f tests/docker-compose.yml exec -T pgcli /bin/sh -c 'echo  "SELECT * FROM accounts;" | pgcli -h postgres -U postgres'
    '';
    test-psql.exec = ''
      build-psql
      ${pkgs.docker}/bin/docker compose -f tests/docker-compose.yml up -d psql
      ${pkgs.docker}/bin/docker compose -f tests/docker-compose.yml exec -T psql /bin/sh -c 'echo  "SELECT * FROM accounts;" | psql -h postgres -U postgres'
    '';
    tests.exec = ''
      test-setup
      test-psql
      test-pgcli
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
