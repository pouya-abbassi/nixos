{ pkgs, ... }:

{
  services.nginx = {
    enable = true;
    statusPage = true;

    virtualHosts = {
      "pouyacode" = {
        serverName = "pouyacode.net";
        forceSSL = true;
        enableACME = true;
        root = "/var/www/pouyacode";

        locations = {
          "/" = {
            tryFiles = "$uri $uri/ =404";
            index = "index.html";
          };

          "~* \.(?:html|xml)$".extraConfig = "
              expires 1d;
              add_header Pragma public;
              add_header Cache-Control \"public\";
              ";

          "~* \.(?:ico|css|js|gif|jpe?g|png|woff2)$".extraConfig = "
              expires 30d;
              add_header Pragma public;
		          add_header Cache-Control \"public\";
              ";

          "/report.html".extraConfig = "
              access_log off;
              ";
        };
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "me@pouyacode.net";
  };

  systemd.services.goaccess = {
    serviceConfig = {
      User = "nginx";
      Group = "nginx";
      ExecStart = "${pkgs.goaccess}/bin/goaccess /var/log/nginx/access.log -o /var/www/pouyacode/report.html --log-format=COMBINED --real-time-html --ssl-cert=/var/lib/acme/pouyacode.net/fullchain.pem --ssl-key=/var/lib/acme/pouyacode.net/key.pem";
    };
    wantedBy = [ "multi-user.target" ];
  };

}
