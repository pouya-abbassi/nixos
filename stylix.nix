{ config, pkgs, ... }:

{
  stylix.image = ./xor.png;
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
