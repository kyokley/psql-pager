{
  description = "Universal SQL Client";

  # Nixpkgs / NixOS version to use.
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    # to work with older version of flakes
    lastModifiedDate = self.lastModifiedDate or self.lastModified or "19700101";

    # Generate a user-friendly version number.
    version = builtins.substring 0 8 lastModifiedDate;

    # System types to support.
    supportedSystems = ["x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin"];

    # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

    # Nixpkgs instantiated for supported system types.
    nixpkgsFor = forAllSystems (system:
      import nixpkgs {
        inherit system;
        overlays = [self.overlays.default];
      });
  in {
    # A Nixpkgs overlay.
    overlays.default = final: prev: {
      usql = with final;
        stdenv.mkDerivation {
          name = "usql-${version}";

          src = ./.;
          nativeBuildInputs = [final.makeWrapper];

          buildPhase = ":";

          installPhase = ''
            mkdir -p $out/bin
            mkdir -p $out/share

            cp -r usql $out/share/
            cp common.vim $out/share/usql/

            chmod +x $out/share/usql/usql_pager.sh

            cp ${prev.usql}/bin/usql $out/bin/usql

            wrapProgram $out/bin/usql \
              --set PATH "${prev.lib.makeBinPath [prev.vim prev.usql prev.coreutils]}" \
              --set PAGER $out/share/usql/usql_pager.sh
          '';
        };

      psql = let
        postgres_version = "postgresql_17";
      in
        with final;
          stdenv.mkDerivation {
            name = "psql-${version}";

            src = ./.;
            nativeBuildInputs = [final.makeWrapper];

            buildPhase = ":";

            installPhase = ''
              mkdir -p $out/bin
              mkdir -p $out/share

              cp -r psql $out/share/
              cp common.vim $out/share/psql/

              chmod +x $out/share/psql/psql_pager.sh

              cp ${prev.${postgres_version}}/bin/psql $out/bin/psql

              wrapProgram $out/bin/psql \
                --set PATH "${prev.lib.makeBinPath [prev.vim prev.coreutils]}" \
                --set PAGER $out/share/psql/psql_pager.sh
            '';
          };

      pgcli = with final;
        stdenv.mkDerivation {
          name = "pgcli-${version}";

          src = ./.;
          nativeBuildInputs = [final.makeWrapper];

          buildPhase = ":";

          installPhase = ''
            mkdir -p $out/bin
            mkdir -p $out/share

            cp -r pgcli $out/share/
            cp common.vim $out/share/pgcli/

            chmod +x $out/share/pgcli/pgcli_pager.sh

            cp ${prev.pgcli}/bin/pgcli $out/bin/pgcli

            wrapProgram $out/bin/pgcli \
              --set PATH "${prev.lib.makeBinPath [prev.vim prev.pgcli prev.coreutils]}" \
              --set PAGER $out/share/pgcli/pgcli_pager.sh
          '';
        };
    };

    # Provide some binary packages for selected system types.
    packages = forAllSystems (system: {
      inherit (nixpkgsFor.${system}) usql;
      inherit (nixpkgsFor.${system}) psql;
      inherit (nixpkgsFor.${system}) pgcli;
      usql-image = nixpkgsFor.${system}.dockerTools.buildImage {
        name = "kyokley/usql";
        tag = "latest";
        copyToRoot = nixpkgsFor.${system}.buildEnv {
          name = "image-root";
          paths = [self.packages.${system}.usql];
          pathsToLink = ["/bin"];
        };
        runAsRoot = ''
          #!${nixpkgsFor.${system}.runtimeShell}
          ${nixpkgsFor.${system}.dockerTools.shadowSetup}
        '';
        config = {
          Entrypoint = ["/bin/usql"];
        };
      };

      psql-image = nixpkgsFor.${system}.dockerTools.buildImage {
        name = "kyokley/psql";
        tag = "latest";
        copyToRoot = nixpkgsFor.${system}.buildEnv {
          name = "image-root";
          paths = [self.packages.${system}.psql];
          pathsToLink = ["/bin"];
        };
        config = {
          Entrypoint = ["/bin/psql"];
        };
      };

      pgcli-image = nixpkgsFor.${system}.dockerTools.buildImage {
        name = "kyokley/pgcli";
        tag = "latest";
        copyToRoot = nixpkgsFor.${system}.buildEnv {
          name = "image-root";
          paths = [self.packages.${system}.pgcli];
          pathsToLink = ["/bin"];
        };
        config = {
          Entrypoint = ["/bin/pgcli"];
        };
      };

      default = self.packages.${system}.usql;
    });

    # A NixOS module, if applicable (e.g. if the package provides a system service).
    nixosModules = {
      usql = {pkgs, ...}: {
        nixpkgs.overlays = [self.overlays.default];

        environment.systemPackages = [pkgs.usql];
      };
      psql = {pkgs, ...}: {
        nixpkgs.overlays = [self.overlays.default];

        environment.systemPackages = [pkgs.psql];
      };
      pgcli = {pkgs, ...}: {
        nixpkgs.overlays = [self.overlays.default];

        environment.systemPackages = [pkgs.pgcli];
      };
    };

    # Tests run by 'nix flake check' and by Hydra.
    checks =
      forAllSystems
      (
        system:
          with nixpkgsFor.${system};
            {
              inherit (self.packages.${system}) usql;
              inherit (self.packages.${system}) psql;
              inherit (self.packages.${system}) pgcli;

              # Additional tests, if applicable.
              test = stdenv.mkDerivation {
                name = "pager-test-${version}";

                buildInputs = [usql psql pgcli];

                unpackPhase = "true";

                buildPhase = ''
                  echo 'running some integration tests'
                  usql --version
                  psql --version
                  pgcli --version
                '';

                installPhase = "mkdir -p $out";
              };
            }
            // lib.optionalAttrs stdenv.isLinux {
              # A VM test of the NixOS module.
              vmTest = with import (nixpkgs + "/nixos/lib/testing-python.nix") {
                inherit system;
              };
                makeTest {
                  name = "test";
                  nodes = {
                    client = {...}: {
                      imports = [
                        self.nixosModules.usql
                        self.nixosModules.psql
                        self.nixosModules.pgcli
                      ];
                    };
                  };

                  testScript = ''
                    start_all()
                    client.wait_for_unit("multi-user.target")
                    client.succeed("usql --version")
                    client.succeed("psql --version")
                    client.succeed("pgcli --version")
                  '';
                };
            }
      );
  };
}
