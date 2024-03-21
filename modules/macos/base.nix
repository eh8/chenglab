{pkgs, ...}: {
  imports = [
    ./dock.nix
  ];

  nix = {
    package = pkgs.nix;
    gc = {
      automatic = true;
      interval.Weekday = 0;
      options = "--delete-older-than 1w";
    };
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
  };

  programs.zsh.enable = true;
  security.pam.enableSudoTouchIdAuth = true;
  services.nix-daemon.enable = true;
  services.tailscale.enable = true;
  users.users.eh8.home = "/Users/eh8";

  system = {
    startup.chime = false;
    defaults = {
      dock.autohide = true;
      dock.mru-spaces = false;
      dock.tilesize = 96;
      dock.wvous-br-corner = 4;
      dock.wvous-bl-corner = 11;
      finder.AppleShowAllExtensions = true;
      finder.FXPreferredViewStyle = "clmv";
      loginwindow.LoginwindowText = "If lost, contact eric@chengeric.com";
      screencapture.location = "~/OneDrive/30-39 Hobbies/34 Photos/34.01 Screenshots";
      menuExtraClock.ShowSeconds = true;
      menuExtraClock.Show24Hour = true;
      NSGlobalDomain.AppleICUForce24HourTime = true;
      menuExtraClock.ShowAMPM = false;
      NSGlobalDomain.AppleInterfaceStyle = "Dark";
      # inspo: https://apple.stackexchange.com/questions/261163/default-value-for-nsglobaldomain-initialkeyrepeat
      NSGlobalDomain.KeyRepeat = 2;
      NSGlobalDomain.InitialKeyRepeat = 15;
    };
  };

  local = {
    dock.enable = true;
    dock.entries = [
      {path = "/System/Applications/Launchpad.app";}
      {path = "/Applications/Firefox.app";}
      {path = "/Applications/Alacritty.app";}
      {path = "/Applications/Cursor.app";}
      {path = "/System/Applications/Messages.app";}
      {path = "/Applications/Messenger.app";}
      {path = "/Applications/1Password.app";}
      {path = "/Applications/Obsidian.app";}
      {path = "/System/Applications/System Settings.app";}
    ];
  };

  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 4;
}
