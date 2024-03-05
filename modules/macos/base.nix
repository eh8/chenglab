{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.nix-homebrew.darwinModules.nix-homebrew
    ./dock.nix
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";

  environment.systemPackages = with pkgs; [
    nixos-rebuild
  ];

  services.nix-daemon.enable = true;
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

  system.defaults = {
    dock.autohide = true;
    dock.mru-spaces = false;
    finder.AppleShowAllExtensions = true;
    finder.FXPreferredViewStyle = "clmv";
    loginwindow.LoginwindowText = "If lost, contact eric@chengeric.com";
    screencapture.location = "~/OneDrive/30-39 Hobbies/34 Photos/";
    screensaver.askForPasswordDelay = 10;
  };

  # Mute that loud ass bootup sound
  system.startup.chime = false;

  security.pam.enableSudoTouchIdAuth = true;

  users.users.eh8.home = "/Users/eh8";

  services.tailscale.enable = true;

  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = "eh8";
    taps = {
      "homebrew/homebrew-cask-fonts" = inputs.homebrew-cask-fonts;
    };
    mutableTaps = false;
  };

  homebrew = {
    enable = true;
    global = {
      autoUpdate = false;
    };
    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "zap";
    };
    brews = [
      "trash"
    ];
    casks = [
      "1password"
      "1password-cli"
      "alacritty"
      "audacity"
      "betterdisplay"
      "caffeine"
      "camo-studio"
      "cursor"
      "discord"
      "dropbox"
      "firefox"
      "font-inter"
      "font-iosevka-ss08"
      "google-chrome"
      "handbrake"
      "inkscape"
      "mac-mouse-fix"
      "mpv"
      "ngrok"
      "obsidian"
      "rar"
      "raycast"
      "screen-studio"
      "spotify"
      "the-unarchiver"
      "transmission"
      "visual-studio-code"
      "vlc"
    ];
    masApps = {
      "1Password for Safari" = 1569813296;
      "GarageBand" = 682658836;
      "Infuse" = 1136220934;
      "Messenger" = 1480068668;
      "Microsoft Excel" = 462058435;
      "Microsoft PowerPoint" = 462062816;
      "Microsoft Word" = 462054704;
      "OneDrive" = 823766827;
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

  system.stateVersion = 4;
}
