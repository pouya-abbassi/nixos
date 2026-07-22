{ config, ... }: {

  age = {
    identityPaths = [ "/root/.ssh/id_ed25519" ];
    secrets.searx = {
      file = ../secrets/searx.age;
      owner = "searx";
      group = "searx";
    };
  };

  services.searx = {
    enable = true;
    redisCreateLocally = true;
    environmentFile = config.age.secrets.searx.path;
    settings = {
      use_default_settings = true;
      general = {
        instance_nam = "PouyaSearch";
        enable_metrics = false;
      };
      search = {
        autocomplete = "duckduckgo";
        favicon_resolver = "duckduckgo";
        ban_time_on_fail = 0;
        max_ban_time_on_fail = 5;
      };
      server = {
        port = 3838;
        secret_key = "$SEARX_SECRET_KEY";
        image_proxy = true;
        method = "GET";
      };
      ui = {
        default_locale = "en";
        query_in_title = true;
        center_alignment = true;
        hotkeys = "vim";
        theme_args.simple_style = "dark";
      };
      outgoing = {
        request_timeout = 30.0;
        max_request_timeout = 30.0;
      };
    };
  };
}
