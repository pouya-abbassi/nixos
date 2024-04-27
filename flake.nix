{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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
          ./configuration.nix
          ./stylix.nix
          stylix.nixosModules.stylix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.pouya = import ./home.nix;

            home-manager.extraSpecialArgs = { inherit fg42; };
          }
        ];
      };
    };
  };
}
