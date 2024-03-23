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

  services = {
    nix-daemon.enable = true;
    tailscale.enable = true;
  };

  users.users.eh8.home = "/Users/eh8";

  system = {
    startup.chime = false;
    defaults = {
      loginwindow.LoginwindowText = "If lost, contact eric@chengeric.com";
      screencapture.location = "~/OneDrive/30-39 Hobbies/34 Photos/34.01 Screenshots";

      dock = {
        autohide = true;
        mru-spaces = false;
        tilesize = 96;
        wvous-br-corner = 4;
        wvous-bl-corner = 11;
      };

      finder = {
        AppleShowAllExtensions = true;
        FXPreferredViewStyle = "clmv";
      };

      menuExtraClock = {
        ShowSeconds = true;
        Show24Hour = true;
        ShowAMPM = false;
      };

      NSGlobalDomain = {
        AppleICUForce24HourTime = true;
        AppleInterfaceStyle = "Dark";
        # inspo: https://apple.stackexchange.com/questions/261163/default-value-for-nsglobaldomain-initialkeyrepeat
        KeyRepeat = 2;
        InitialKeyRepeat = 15;
      };
    };
  };

  local = {
    dock = {
      enable = true;
      entries = [
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
  };

  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 4;
}
