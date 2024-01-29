{ config, pkgs, ... }:

{
  users.users.eh8 = {
    isNormalUser = true;
    home = "/home/eh8";
    description = "User for eh8";
    extraGroups = [ "wheel" "docker" ]; # Add user to the wheel group for administrative privileges and docker for container management
    # User-specific configurations can be added here
    # For example, shell, packages, or services specific to the user
  };

  # Set the user's shell if desired
  # users.users.eh8.shell = pkgs.zsh;

  # You can specify user-specific packages
  # users.users.eh8.packages = with pkgs; [
  #   git
  #   vim
  # ];

  # User services can be enabled here
  # For example, to start a user-specific service or timer
  # systemd.user.services = {
  #   aUserSpecificService = {
  #     # Service definition goes here
  #   };
  # };
}
