{...}: {
  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        # Gnome dark mode
        color-scheme = "prefer-dark";
      };
      # inspo: https://github.com/NixOS/nixpkgs/issues/114514
      "org/gnome/mutter" = {
        # Fractional scaling
        experimental-features = ["scale-monitor-framebuffer"];
      };
    };
  };
}
