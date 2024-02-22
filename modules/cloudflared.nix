{ config, pkgs, ... }:

{
  services.cloudflared = {
    enable = true;
  };
}