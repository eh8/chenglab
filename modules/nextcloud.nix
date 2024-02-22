{
  config,
  pkgs,
  ...
}: {
  # Network linker
  system.activationScripts.NextcloudNetwork = let
    backend = config.virtualisation.oci-containers.backend;
    backendBin = "${pkgs.${backend}}/bin/${backend}";
  in ''
    ${backendBin} network create nextcloud-net --subnet 172.20.0.0/16 || true
  '';

  # Database
  virtualisation.oci-containers.containers."nextcloud-db" = {
    autoStart = true;
    image = "mariadb:10.5";
    cmd = ["--transaction-isolation=READ-COMMITTED" "--binlog-format=ROW"];
    volumes = [
      "nextcloud-db:/var/lib/mysql"
    ];
    ports = ["3306:3306"];
    environment = {
      MYSQL_ROOT_PASSWORD = "nextcloud";
      MYSQL_PASSWORD = "nextcloud";
      MYSQL_DATABASE = "nextcloud";
      MYSQL_USER = "nextcloud";
    };
    extraOptions = ["--network=nextcloud-net"];
  };

  # NextCloud
  virtualisation.oci-containers.containers."nextcloud" = {
    image = "nextcloud";
    ports = ["8080:80"];
    environment = {
      MYSQL_PASSWORD = "nextcloud";
      MYSQL_DATABASE = "nextcloud";
      MYSQL_USER = "nextcloud";
      MYSQL_HOST = "nextcloud-db";
    };
    dependsOn = ["nextcloud-db"];
    volumes = [
      "/media/Containers/Nextcloud/data:/var/www/html"
    ];
    extraOptions = ["--network=nextcloud-net"];
  };

  services.caddy = {
    virtualHosts."cloud.chengeric.com".extraConfig = ''
      reverse_proxy localhost:8080
    '';
  };
}
