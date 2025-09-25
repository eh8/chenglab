{
  pkgs,
  vars,
  ...
}: {
  imports = [
    ./_dock.nix
    ./_packages.nix
  ];

  nixpkgs.config.allowUnfree = true;
  nix = {
    package = pkgs.nix;
    gc = {
      automatic = true;
      interval = {
        Weekday = 0;
        Hour = 0;
        Minute = 0;
      };
      options = "--delete-older-than 7d";
    };
    optimise = {
      automatic = true;
    };
    settings = {
      experimental-features = "nix-command flakes";
      trusted-users = [
        "root"
        "@admin"
      ];
    };
  };

  # inspo: https://github.com/nix-darwin/nix-darwin/issues/1339
  ids.gids.nixbld = 350;

  programs.zsh.enable = true;
  security.pam.services.sudo_local.touchIdAuth = true;

  services = {
    tailscale.enable = true;
  };

  users.users.${vars.userName}.home = "/Users/${vars.userName}";

  system = {
    primaryUser = vars.userName;
    startup.chime = false;
    defaults = {
      loginwindow.LoginwindowText = "If lost, contact ${vars.userEmail}";
      screencapture.location = "~/OneDrive/30-39 Hobbies/34 Photos/34.01 Screenshots";

      dock = {
        autohide = true;
        mru-spaces = false;
        tilesize = 96;
        wvous-br-corner = 4;
        wvous-bl-corner = 11;
        wvous-tr-corner = 5;
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
      username = vars.userName;
      entries = [
        {path = "/Applications/Firefox.app";}
        {path = "/Applications/Alacritty.app";}
        {path = "/Applications/Zed.app";}
        {path = "/Applications/Discord.app";}
        {path = "/Applications/Messages.app";}
        {path = "/Applications/Messenger.app";}
        {path = "/Applications/1Password.app";}
        {path = "/Applications/Obsidian.app";}
        {path = "/Applications/System Settings.app";}
      ];
    };
  };

  system.activationScripts.Wallpaper.text = ''
    echo >&2 "Setting up wallpaper..."
    osascript -e 'tell application "Finder" to set desktop picture to POSIX file "/System/Library/Desktop Pictures/Solid Colors/Black.png"'
  '';

  system.stateVersion = 4;
}
