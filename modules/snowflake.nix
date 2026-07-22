{ ... }: {

  networking = {
    firewall = {
      enable = true;
      allowedUDPPortRanges = [
        { from = 32768; to = 60999; }
      ];
    };
  };

  services.snowflake-proxy = {
    enable = true;
    capacity = 100;
  };

}
