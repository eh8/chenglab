{
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.nix-homebrew.darwinModules.nix-homebrew
  ];

  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = "eh8";
    mutableTaps = false;
    taps = {
      "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
      "homebrew/homebrew-core" = inputs.homebrew-core;
    };
  };

  homebrew = {
    enable = true;
    global = {
      autoUpdate = true;
    };
    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "zap";
    };
    brews = [
      "trash"
    ];
    taps = builtins.attrNames config.nix-homebrew.taps;
    casks = [
      "1password-cli"
      "1password"
      "alacritty"
      "audacity"
      "betterdisplay"
      "caffeine"
      "camo-studio"
      "cursor"
      "discord"
      "dropbox"
      "firefox"
      "google-chrome"
      "handbrake"
      "inkscape"
      "mac-mouse-fix"
      "mullvadvpn"
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
      "whatsapp"
    ];
    masApps = {
      "1Password for Safari" = 1569813296;
      "GarageBand" = 682658836;
      "Infuse" = 1136220934;
      "Messenger" = 1480068668;
      "Microsoft Excel" = 462058435;
      "Microsoft PowerPoint" = 462062816;
      "Microsoft Remote Desktop" = 1295203466;
      "Microsoft Word" = 462054704;
      "OneDrive" = 823766827;
      "Tailscale" = 1475387142;
    };
  };
}
