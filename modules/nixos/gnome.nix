{pkgs, ...}: {
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.udev.packages = with pkgs; [gnome.gnome-settings-daemon];
  environment.systemPackages = with pkgs; [gnomeExtensions.appindicator];
}
