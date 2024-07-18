{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
    };
    fg42.url = "git+https://devheroes.codes/FG42/FG42";
  };

  outputs = inputs@{ nixpkgs, home-manager, stylix, fg42, ... }: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./strix/configuration.nix
          ./strix/stylix.nix
          stylix.nixosModules.stylix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.pouya = import ./strix/home.nix;

            home-manager.extraSpecialArgs = { inherit fg42; };
          }
        ];
      };
      vps = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./vps/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.pouya = import ./vps/home.nix;
          }
        ];
      };
    };
  };
}
