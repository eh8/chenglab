{
  config,
  pkgs,
  ...
}: {
  sops.secrets.nextcloud-adminpassfile = {};
  sops.secrets.nextcloud-adminpassfile.owner = "nextcloud";
  sops.secrets.nextcloud-adminpassfile.group = "nextcloud";

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud28;
    hostName = "pancake.chengeric.com";
    https = true;
    config.adminuser = "admin";
    config.adminpassFile = config.sops.secrets.nextcloud-adminpassfile.path;
    settings.trusted_domains = ["10.10.0.242" "0.0.0.0" "127.0.0.1" "pancake.chengeric.com"];
  };

  services.nginx = {
    enable = true;
    virtualHosts = {
      "${config.services.nextcloud.hostName}" = {
        forceSSL = true;
        useACMEHost = "chengeric.com";
      };
    };
  };

  fileSystems."/var/lib/nextcloud" = {
    device = "/nix/persist/var/lib/nextcloud";
    fsType = "none";
    options = ["bind"];
  };
}
