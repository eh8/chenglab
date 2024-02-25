{ config, pkgs, ... }:

{
  services.home-assistant = {
    enable = true;
    openFirewall = true;
  };

  services.caddy = {
    virtualHosts."home.chengeric.com".extraConfig = ''
      reverse_proxy localhost:8123
    '';
  };
}
