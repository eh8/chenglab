{ config, pkgs, ... }:

{
  # https://kressle.in/articles/2022/watchtower-on-docker-with-nixos
  virtualisation.oci-containers.containers."watchtower" = {
    autoStart = true;
    image = "containrrr/watchtower";
    volumes = [
      "/var/run/docker.sock:/var/run/docker.sock"
    ]; 
  };
}
