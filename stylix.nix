{ config, pkgs, ... }:

{
  stylix.enable = true;
  stylix.image = ./wall.jpg;
  stylix.polarity = "dark";
  stylix.fonts = {
    monospace = {
      package = pkgs.fira-mono;
      name = "Fira Mono";
    };

    sizes = {
      applications = 10;
      desktop = 10;
      popups = 10;
      terminal = 10;
    };
  };
} 
