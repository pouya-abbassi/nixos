{ config, pkgs, ... }: {

  users.users.${config.strix.user} = {
    extraGroups = [
      "wireshark"
    ];
  };

  programs.wireshark = {
    enable = true;
    usbmon.enable = true;
  };

  home-manager.users.${config.strix.user} = {
    home.packages = [ pkgs.wireshark ];
  };
}
