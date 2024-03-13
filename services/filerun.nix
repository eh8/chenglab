{pkgs, ...}: {
  imports = [
    ./acme.nix
  ];

  virtualisation.oci-containers.containers."filerun-mariadb" = {
    image = "mariadb:10.1";
    environment = {
      "MYSQL_ROOT_PASSWORD" = "randompasswd";
      "MYSQL_USER" = "filerun";
      "MYSQL_PASSWORD" = "randompasswd";
      "MYSQL_DATABASE" = "filerundb";
    };
    volumes = ["/var/lib/filerun/db:/var/lib/mysql"];
    extraOptions = ["--network=filerun_network"];
  };

  virtualisation.oci-containers.containers."filerun" = {
    image = "filerun/filerun:8.1";
    environment = {
      "FR_DB_HOST" = "filerun-mariadb";
      "FR_DB_PORT" = "3306";
      "FR_DB_NAME" = "filerundb";
      "FR_DB_USER" = "filerun";
      "FR_DB_PASS" = "randompasswd";
      "APACHE_RUN_USER" = "filerun";
      "APACHE_RUN_USER_ID" = "600";
      "APACHE_RUN_GROUP" = "filerun";
      "APACHE_RUN_GROUP_ID" = "600";
    };
    ports = ["8080:80"];
    volumes = [
      "/var/lib/filerun/html:/var/www/html"
      "/var/lib/filerun/user-files:/user-files"
    ];
    extraOptions = ["--network=filerun_network"];
    dependsOn = ["filerun-mariadb"];
  };

  systemd.services.init-filerun-network-and-files = {
    description = "Create the network bridge filerun_network for filerun.";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];
    serviceConfig.Type = "oneshot";
    # https://discourse.nixos.org/t/podman-container-to-container-networking/11647/2
    script = ''
      ${pkgs.podman}/bin/podman network exists filerun_network || ${pkgs.podman}/bin/podman network create filerun_network
    '';
  };

  users = {
    users.filerun = {
      group = "filerun";
      isSystemUser = true;
      uid = 600;
      extraGroups = ["filerun"];
    };

    groups.filerun = {
      gid = 600;
      members = ["filerun"];
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/filerun 755 filerun filerun"
    "d /var/lib/filerun/html 755 filerun filerun"
    "d /var/lib/filerun/user-files 755 filerun filerun"
  ];

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts = {
      "filerun.chengeric.com" = {
        forceSSL = true;
        useACMEHost = "chengeric.com";
        locations."/" = {
          proxyPass = "http://127.0.0.1:8080";
        };
      };
    };
  };

  fileSystems."/var/lib/filerun" = {
    device = "/nix/persist/var/lib/filerun";
    fsType = "none";
    options = ["bind"];
  };

  fileSystems."/var/lib/containers" = {
    device = "/nix/persist/var/lib/containers";
    fsType = "none";
    options = ["bind"];
  };
}
