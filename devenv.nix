{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  # https://devenv.sh/basics/
  env = {
  };

  # https://devenv.sh/packages/
  packages = [pkgs.docker];

  # https://devenv.sh/languages/
  languages = {
    python = {
      enable = false;
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
      nix build ".#$@-image"
      docker load < result
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
      sleep 2
      docker compose -f tests/docker-compose.yml exec -T postgres /bin/bash -c 'psql -U postgres -f /app/setup.sql'
    '';
    test-down.exec = ''
      docker compose -f tests/docker-compose.yml down -v --remove-orphans
    '';
    test-pgcli.exec = ''
      build-pgcli
      docker compose -f tests/docker-compose.yml run pgcli -h postgres -U postgres -c "SELECT * FROM accounts;"
    '';
    test-psql.exec = ''
      build-psql
      docker compose -f tests/docker-compose.yml run psql -h postgres -U postgres -c "SELECT * FROM accounts;"
    '';
    test-usql.exec = ''
      build-usql
      docker compose -f tests/docker-compose.yml run usql postgres://postgres@postgres -c "SELECT * FROM accounts;"
    '';
    tests.exec = ''
      set -e
      build
      test-setup
      test-psql
      # test-pgcli # TODO: Figure out how to pipe this into pgcli
      # test-usql # TODO: Figure out how to close pager in Github Action testing
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
  git-hooks.hooks = {
    alejandra.enable = true;
  };

  # See full reference at https://devenv.sh/reference/options/
}
