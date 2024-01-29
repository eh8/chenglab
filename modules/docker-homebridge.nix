{ config, pkgs, lib, ... }:

{
  # Docker service configuration
  services.docker = {
    enable = true;
    logDriver = "json-file";
    logOpts = {
      "max-size" = "10m";
      "max-file" = "3";
    };
    storageDriver = "overlay2";
  };

  # Homebridge Docker container configuration
  systemd.services.homebridge = {
    after = [ "docker.service" ];
    requires = [ "docker.service" ];
    wantedBy = [ "multi-user.target" ];
    script = ''
      # Pull the latest homebridge image
      docker pull oznu/homebridge:latest

      # Stop the existing homebridge container if it's running
      docker stop homebridge || true
      docker rm homebridge || true

      # Start the homebridge container
      docker run --name=homebridge \
        --net=host \
        --env=HOMEBRIDGE_CONFIG_UI=1 \
        --env=HOMEBRIDGE_CONFIG_UI_PORT=8581 \
        --env=PGID=$(id -g) \
        --env=PUID=$(id -u) \
        --volume=/var/lib/homebridge:/homebridge \
        --restart=always \
        oznu/homebridge:latest
    '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };

  # Ensure the Docker daemon is started before the Homebridge service
  systemd.services.homebridge.requires = [ "docker.service" ];

  # Create a directory for Homebridge configuration and persist data
  systemd.tmpfiles.rules = [
    "d /var/lib/homebridge 0755 ${config.users.users.eh8.name} ${config.users.users.eh8.name} -"
  ];
}
