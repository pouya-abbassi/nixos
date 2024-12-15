{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../common/configuration.nix
    ./nginx.nix
  ];

  zramSwap.enable = false;

  networking = {
    nameservers = [ "1.1.1.1" "1.0.0.1" ];
    hostName = "pouyacode";
    domain = "pouyacode.net";
    nat = {
      enable = true;
      enableIPv6 = true;
      externalInterface = "ens3";
      internalInterfaces = [ "wg0" ];
    };
    firewall = {
      allowedTCPPorts = [
        80
        443
        7890 # GoAccess
      ];
    };
  };

  age = {
    identityPaths = [ "/root/.ssh/id_ed25519" ];
    secrets = {
      wg-server.file = ../secrets/wg-server.age;
    };
  };

  networking.wireguard.interfaces = {
    wg0 = {
      ips = [
        "10.100.0.1/24"
        "fd0d:86fa:c3bc::1/64"
      ];
      listenPort = 51820;

      postSetup = ''
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o ens3 -j MASQUERADE
        ${pkgs.iptables}/bin/ip6tables -t nat -A POSTROUTING -s fd0d:86fa:c3bc::/64 -o ens3 -j MASQUERADE
      '';
      postShutdown = ''
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o ens3 -j MASQUERADE
        ${pkgs.iptables}/bin/ip6tables -t nat -D POSTROUTING -s fd0d:86fa:c3bc::/64 -o ens3 -j MASQUERADE
      '';

      privateKeyFile = config.age.secrets.wg-server.path;

      peers = [
        {
          publicKey = "iP0f5LZ37LzUsn2PKRknj15zcY/dMZXVZNXl+TNnRhk=";
          allowedIPs = [
            "10.100.0.2/32"
            "fd0d:86fa:c3bc::2/64"
          ];
        }
        {
          publicKey = "S02fBhnlSADsPQ9CF4WdcbTvf/ePtiFlb8T3bTZmgTA=";
          allowedIPs = [
            "10.100.0.3/32"
            "fd0d:86fa:c3bc::3/64"
          ];
        }
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
