{ config, pkgs, ... }:

{
  imports = [
    # Include the hardware configuration
    ./hardware-configuration.nix

    # Include common services configurations
    ./modules/common-services.nix

    # Service modules
    ./modules/jellyfin.nix
    ./modules/nextcloud.nix
    ./modules/nextdns.nix
    ./modules/docker-homebridge.nix
  ];

  # Define user "eh8"
  users.users.eh8 = {
    isNormalUser = true;
    home = "/home/eh8";
    description = "User for eh8";
    extraGroups = [ "wheel" ]; # Add user to the wheel group for administrative privileges
    # Include other user-specific configurations if necessary
  };

  # Define the system's hostname
  networking.hostName = "homelab"; # Replace with your desired hostname

  # Set the timezone
  time.timeZone = "UTC"; # Replace with your timezone

  # Locale settings
  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [ "en_US.UTF-8/UTF-8" ];
  };

  # Enable the firewall
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ]; # Open the SSH port

  # Set up the system-wide package management
  environment.systemPackages = with pkgs; [
    # Add packages here if needed
  ];

  # System-wide Nix settings
  nix = {
    # Enable Nix Flakes
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Define any additional system-wide settings here
}
{ config, pkgs, lib, ... }:

{
  # NextDNS configuration for the homelab

  services.nextdns = {
    enable = true;
    settings = {
      # Replace "your-config-id" with your actual NextDNS configuration ID
      config = "your-config-id";
      # Set the listening address and port for NextDNS
      listen = "127.0.0.1:53";
      # Additional settings can be configured as needed
      # For example, to use NextDNS with caching enabled:
      cacheSize = 10 * 1024 * 1024; # 10MB cache size
      # To report each device name to NextDNS:
      reportClientInfo = true;
      # To use NextDNS logs for privacy-friendly analytics and filtering:
      logQueries = true;
      # To automatically setup the system to use NextDNS as the resolver:
      setupRouter = true;
    };
  };

  # Ensure that the NextDNS service starts before network.target to act as the system's DNS resolver
  systemd