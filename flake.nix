{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/c5c98cfc7060e89443cb0162412d9f45d992c81a";
    home-manager.url = "github:nix-community/home-manager/36317d4d38887f7629876b0e43c8d9593c5cc48d";
    stylix.url = "github:danth/stylix/1ff9d37d27377bfe8994c24a8d6c6c1734ffa116";
    fg42.url = "git+https://devheroes.codes/FG42/FG42?rev=36ea7f031c10539c66ff15739a0a97e8c1d10463";
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
