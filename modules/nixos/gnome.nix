{pkgs, ...}: {
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  services.udev.packages = with pkgs; [gnome.gnome-settings-daemon];
}
