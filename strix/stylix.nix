{ pkgs, ... }:

{
  stylix.enable = true;
  stylix.image = ./wall.jpg;
  stylix.polarity = "dark";

  stylix.targets.grub.enable = false;

  stylix.cursor = {
    package = pkgs.rose-pine-cursor;
    name = "BreezeX-RosePineDawn-Linux";
    size = 20;
  };

  stylix.fonts = {
    monospace = {
      package = pkgs.fira-code;
      name = "Fira Code";
    };

    sizes = {
      applications = 10;
      desktop = 10;
      popups = 10;
      terminal = 10;
    };
  };
}
