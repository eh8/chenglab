{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./acme.nix
  ];

  sops.secrets.nextcloud-adminpassfile = {};
  sops.secrets.nextcloud-adminpassfile.owner = "nextcloud";
  sops.secrets.nextcloud-adminpassfile.group = "nextcloud";

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud28;
    hostName = "cloud.chengeric.com";
    https = true;
    maxUploadSize = "16G";
    configureRedis = true;
    database.createLocally = true;
    config.adminuser = "admin";
    config.dbtype = "pgsql";
    config.adminpassFile = config.sops.secrets.nextcloud-adminpassfile.path;
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

  fileSystems."/var/lib/postgresql" = {
    device = "/nix/persist/var/lib/postgresql";
    fsType = "none";
    options = ["bind"];
  };
}
