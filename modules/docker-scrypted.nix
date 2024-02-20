{ config, pkgs, ... }:

{
  systemd.tmpfiles.rules = [ "d /var/lib/scrypted 0755 root root" ];

  virtualisation.oci-containers.containers."scrypted" = {
    image = "koush/scrypted:latest";
    volumes = [ "/var/lib/scrypted:/scrypted" ];
    extraOptions = [ "--network=host" ];
  }

  services.caddy = {
    virtualHosts."scrypted.chengeric.com".extraConfig = ''
      reverse_proxy localhost:10443
    '';
  }
}
