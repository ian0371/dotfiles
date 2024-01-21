{
  description = "ian0371 home-manager and nix-darwin";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/*.tar.gz";
    nixpkgs-unstable.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.0.tar.gz"; # used by overlay
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self
    , nixpkgs
    , darwin
    , home-manager
    , ...
    } @ inputs:
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

      darwinConfigWrapper = { system, extraModules ? [ ] }: (inputs.darwin.lib.darwinSystem {
        inherit system;
        specialArgs = { inherit inputs outputs; };
        modules = [
          {
            imports =
              extraModules
              ++
              [
                ./nix-darwin/configuration.nix
              ];
          }
        ];
      });
      hmConfigWrapper = { system, extraModules ? [ ] }: (inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages.${system};
        modules = [
          {
            _module.args.self = self;
            _module.args.inputs = self.inputs;
            imports =
              extraModules
              ++ [
                ./home-manager/home.nix
              ];
          }
        ];
        extraSpecialArgs = { inherit inputs outputs; };
      });
    in
    {
      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt);

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
        ubuntu = hmConfigWrapper {
          system = "x86_64-linux";
          extraModules = [{ home.username = "ubuntu"; }];
        };
        ec2-user = hmConfigWrapper {
          system = "aarch64-linux";
          extraModules = [{ home.username = "ec2-user"; }];
        };
      };
    };
}
