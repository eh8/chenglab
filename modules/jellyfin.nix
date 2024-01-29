{ config, pkgs, lib, ... }:

{
  # Jellyfin media server configuration for the homelab

  services.jellyfin = {
    enable = true;
    # Additional configuration options can be set here
    # For example, to specify the data directory or network settings
  };

  # Ensure the Jellyfin service is enabled and started
  systemd.services.jellyfin = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
  };

  # Open the default Jellyfin web interface port in the firewall
  networking.firewall.allowedTCPPorts = [ 8096 ];

  # If Jellyfin requires any additional packages, they can be added to the systemPackages list
  # environment.systemPackages = with pkgs; [
  #   # Add any Jellyfin-related packages here
  # ];

  # If there are any users or groups that need to be added for Jellyfin, they can be defined here
  # users.users.jellyfin = {
  #   isSystemUser = true;
  #   group = "jellyfin";
  #   home = "/var/lib/jellyfin"; # or wherever Jellyfin's data is stored
  #   createHome = true;
  # };

  # If Jellyfin requires any specific system settings, they can be defined here
  # For example, file system permissions, additional services, etc.
}
