{
  description = "ian0371 home-manager and nix-darwin";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0";
    nixpkgs-unstable.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.0.tar.gz"; # used by overlay
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/3";
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
      lib = nixpkgs.lib;

      systems = [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      forAllSystems = lib.genAttrs systems;

      # Let Determinate Nix handle Nix configuration rather than nix-darwin
      determinateNixModule =
        { ... }:
        {
          determinateNix = {
            enable = true;
            customSettings = {
              experimental-features = "external-builders";
            };
          };
        };

      darwinModules = [
        inputs.determinate.darwinModules.default
        determinateNixModule
        ./nix-darwin/configuration.nix
      ];

      hmModules = extraModules: [
        {
          _module.args.self = self;
          _module.args.inputs = self.inputs;
          imports = extraModules ++ [ ./home-manager/home.nix ];
        }
      ];
    in
    {
      packages = forAllSystems (system: import ./pkgs { pkgs = nixpkgs.legacyPackages.${system}; });

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);

      overlays = import ./overlays { inherit inputs; };
      homeManagerModules = import ./modules/home-manager;

      nixosConfigurations = {
        nixos = lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [ ./nixos/configuration.nix ];
        };
      };

      darwinConfigurations = {
        "Chihyunui-Macmini" = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { inherit inputs outputs; };
          modules = darwinModules;
        };
        "ianxxui-MacBookPro" = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { inherit inputs outputs; };
          modules = darwinModules;
        };
      };

      homeConfigurations = {
        song = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-darwin;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = hmModules [ ];
        };
        yum3 = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = hmModules [ { home.username = "yum3"; } ];
        };
        ubuntu = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = hmModules [ { home.username = "ubuntu"; } ];
        };
        ec2-user = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = hmModules [ { home.username = "ec2-user"; } ];
        };
      };
    };
}
