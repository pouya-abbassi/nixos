{ config, ... }:

{
  home-manager.users.${config.strix.user} = {
    services.tomat = {
      enable = true;
    };
  };
}
