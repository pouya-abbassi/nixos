{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../common/configuration.nix
    ./nginx.nix
  ];

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = false;

  networking = {
    nameservers = [ "1.1.1.1" "1.0.0.1" ];
    hostName = "pouyacode";
    domain = "pouyacode.net";
    firewall = {
      allowedTCPPorts = [
        80
        443
        7890                    # GoAccess
      ];
    };
  };

  services.fail2ban = {
    jails = {
      ngnix-url-probe.settings = {
        enabled = true;
        filter = "nginx-url-probe";
        logpath = "/var/log/nginx/access.log";
        backend = "auto";
        maxretry = 5;
        findtime = 600;
      };
    };
  };

  environment.etc = {
    "fail2ban/filter.d/nginx-url-probe.local".text = pkgs.lib.mkDefault (pkgs.lib.mkAfter ''
      [Definition]
      failregex = ^<HOST>.*(GET /(wp-|admin|boaform|phpmyadmin|\.env|\.git|\.php|\.cgi-bin|xmlrpc)|\.(dll|so|cfm|asp)|(\?|&)(=PHPB8B5F2A0-3C92-11d3-A3A9-4C7B08C10000|=PHPE9568F36-D428-11d2-A769-00AA001ACF42|=PHPE9568F35-D428-11d2-A769-00AA001ACF42|=PHPE9568F34-D428-11d2-A769-00AA001ACF42)|\\x[0-9a-zA-Z]{2})
    '');
  };

  users.users.pouya = {
    isNormalUser = true;
    description = "Pouya";
  };

  environment.systemPackages = with pkgs; [
    bat
    vim
    git
    goaccess
  ];

  system.stateVersion = "23.11";
}
