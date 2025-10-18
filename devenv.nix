{ pkgs, lib, config, inputs, ... }:
let
  set-env = ''
    : ''${USE_HOST_NET:=0}
    if [ $USE_HOST_NET -eq 1 ]
    then
      DOCKER_BUILD_ARGS="--network=host"
    else
      DOCKER_BUILD_ARGS=""
    fi

    export DOCKER_BUILD_ARGS
  '';
in
{
  # https://devenv.sh/basics/
  env = {
    USE_HOST_NET = lib.mkDefault 0;
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
    hello.exec = ''
      echo Welcome to
      ${pkgs.figlet}/bin/figlet -f slant 'PSQL Pager' | ${pkgs.lolcat}/bin/lolcat
      echo
    '';
  };

  # https://devenv.sh/basics/
  enterShell = ''
    hello         # Run scripts directly
  '';

  # https://devenv.sh/tasks/
  # tasks = {
  #   "myproj:setup".exec = "mytool build";
  #   "devenv:enterShell".after = [ "myproj:setup" ];
  # };

  # https://devenv.sh/tests/
  enterTest = ''
  '';

  # https://devenv.sh/git-hooks/
  # git-hooks.hooks.shellcheck.enable = true;

  # See full reference at https://devenv.sh/reference/options/
}
