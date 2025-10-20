{
  description = "Universal SQL Client";

  # Nixpkgs / NixOS version to use.
  inputs.nixpkgs.url = "nixpkgs/nixos-21.05";

  outputs = { self, nixpkgs }:
    let

      # to work with older version of flakes
      lastModifiedDate = self.lastModifiedDate or self.lastModified or "19700101";

      # Generate a user-friendly version number.
      version = builtins.substring 0 8 lastModifiedDate;

      # System types to support.
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # Nixpkgs instantiated for supported system types.
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; overlays = [ self.overlay ]; });

    in

    {

      # A Nixpkgs overlay.
      overlay = final: prev: {

        usql = final.stdenv.mkDerivation rec {
          name = "usql-${version}";

          unpackPhase = ":";

          buildPhase =
            ''
              cat > usql_pager.sh <<EOF
              #! $SHELL
              what=-
              SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
              PLUGIN_DIR="$SCRIPT_DIR/usql/plugin"
              exec ${final.vim}/bin/vim --not-a-term -u $SCRIPT_DIR/common.vim -S $SCRIPT_DIR/usql.vim -c "let &runtimepath='$SCRIPT_DIR/share/' . &runtimepath" -c Less $what
              EOF
              chmod +x usql_pager.sh

              cat > usql <<EOF
              #! $SHELL
              SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
              PAGER=$SCRIPT_DIR/share/usql_pager.sh ${prev.usql}/bin/usql $@
              EOF
              chmod +x usql
            '';

          installPhase =
            ''
              mkdir -p $out/bin
              mkdir -p $out/share

              cp common.vim usql_pager.sh $out/share/
              cp -r ./usql $out/share/
              cp usql $out/bin/usql
            '';
        };

      };

      # Provide some binary packages for selected system types.
      packages = forAllSystems (system:
        {
          inherit (nixpkgsFor.${system}) usql;
        });

      # The default package for 'nix build'. This makes sense if the
      # flake provides only one package or there is a clear "main"
      # package.
      defaultPackage = forAllSystems (system: self.packages.${system}.usql);

      # A NixOS module, if applicable (e.g. if the package provides a system service).
      nixosModules.usql =
        { pkgs, ... }:
        {
          nixpkgs.overlays = [ self.overlay ];

          environment.systemPackages = [ pkgs.usql ];

          #systemd.services = { ... };
        };

      # Tests run by 'nix flake check' and by Hydra.
      checks = forAllSystems
        (system:
          with nixpkgsFor.${system};

          {
            inherit (self.packages.${system}) usql;

            # Additional tests, if applicable.
            test = stdenv.mkDerivation {
              name = "usql-test-${version}";

              buildInputs = [ usql ];

              unpackPhase = "true";

              buildPhase = ''
                echo 'running some integration tests'
                echo TODO: Add tests!!!
              '';

              installPhase = "mkdir -p $out";
            };
          }

          // lib.optionalAttrs stdenv.isLinux {
            # A VM test of the NixOS module.
            vmTest =
              with import (nixpkgs + "/nixos/lib/testing-python.nix") {
                inherit system;
              };

              makeTest {
                nodes = {
                  client = { ... }: {
                    imports = [ self.nixosModules.usql ];
                  };
                };

                testScript =
                  ''
                    start_all()
                    client.wait_for_unit("multi-user.target")
                    client.succeed("hello")
                  '';
              };
          }
        );

    };
}
