{ config, pkgs, ... }:

{
  systemd.tmpfiles.rules = [ "d /var/lib/homebridge 0755 root root" ];

  # https://lmy.medium.com/from-ansible-to-nixos-3a117b140bec
  virtualisation.oci-containers.containers."homebridge" = {
    autoStart = true;
    image = "homebridge/homebridge:latest";
    volumes = [ "/var/lib/homebridge:/homebridge" ];
    extraOptions = [ "--network=host" ];
  }

  services.caddy = {
    virtualHosts."home.chengeric.com".extraConfig = ''
      reverse_proxy localhost:8581
    '';
  }
}
