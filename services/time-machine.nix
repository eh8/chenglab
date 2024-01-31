{ config, pkgs, ... }:

{
  services.netatalk = {
    enable = true;
    settings = {
      Homes = {  # Homes are optional - don't need them for Time Machine
        "basedir regex" = "/home";
        path = "netatalk";
      };
      time-machine = {
          path = "/timemachine";
        "valid users" = "whoever";
          "time machine" = true;
      };
    };
  };

  services.avahi = {
    enable = true;
    nssmdns = true;
    publish = {
      enable = true;
      userServices = true;
    };
  };
}