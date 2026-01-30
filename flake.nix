{
  description = "ian0371 home-manager and nix-darwin";

  inputs = {
    # nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/*.tar.gz";
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/3";
    nixpkgs-unstable.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.0.tar.gz"; # used by overlay
    darwin = {
      url = "https://flakehub.com/f/nix-darwin/nix-darwin/0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      darwin,
      home-manager,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      systems = [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;

      darwinConfigWrapper =
        {
          system,
          extraModules ? [ ],
        }:
        (inputs.darwin.lib.darwinSystem {
          inherit system;
          specialArgs = { inherit inputs outputs; };
          modules = [
            inputs.determinate.darwinModules.default
            (
              {
                config,
                lib,
                ...
              }:
              {
                # Let Determinate Nix handle Nix configuration rather than nix-darwin
                determinateNix = {
                  enable = true;
                  customSettings = {
                    experimental-features = "external-builders";
                    # external-builders = ''[{"systems":["aarch64-linux","x86_64-linux"],"program":"/usr/local/bin/determinate-nixd","args":["builder"]}]'';
                  };
                };
              }
            )
            {
              imports = extraModules ++ [
                ./nix-darwin/configuration.nix
              ];
            }
          ];
        });
      hmConfigWrapper =
        {
          system,
          extraModules ? [ ],
        }:
        (inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = inputs.nixpkgs.legacyPackages.${system};
          modules = [
            {
              _module.args.self = self;
              _module.args.inputs = self.inputs;
              imports = extraModules ++ [
                ./home-manager/home.nix
              ];
            }
          ];
          extraSpecialArgs = { inherit inputs outputs; };
        });
    in
    {
      packages = forAllSystems (system: import ./pkgs { pkgs = nixpkgs.legacyPackages.${system}; });
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);

      overlays = import ./overlays { inherit inputs; };
      homeManagerModules = import ./modules/home-manager;

      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./nixos/configuration.nix
          ];
        };
      };

      darwinConfigurations = {
        # scutil --get LocalHostName
        "Chihyunui-Macmini" = darwinConfigWrapper { system = "aarch64-darwin"; };
        "ianxxui-MacBookPro" = darwinConfigWrapper { system = "aarch64-darwin"; };
      };

      homeConfigurations = {
        song = hmConfigWrapper { system = "aarch64-darwin"; };
        yum3 = hmConfigWrapper {
          system = "aarch64-linux";
          extraModules = [ { home.username = "yum3"; } ];
        };
        ubuntu = hmConfigWrapper {
          system = "x86_64-linux";
          extraModules = [ { home.username = "ubuntu"; } ];
        };
        ec2-user = hmConfigWrapper {
          system = "x86_64-linux";
          extraModules = [ { home.username = "ec2-user"; } ];
        };
      };
    };
}
