{
  config,
  inputs,
  vars,
  ...
}:
{
  imports = [
    inputs.nix-homebrew.darwinModules.nix-homebrew
  ];

  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = vars.userName;
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
      "discord"
      "exifcleaner"
      "firefox"
      "figma-agent"
      "google-chrome"
      "grandperspective"
      "handbrake-app"
      "linearmouse"
      "obsidian"
      "rar"
      "raycast"
      "screen-studio"
      "spotify"
      "steam"
      "the-unarchiver"
      "visual-studio-code"
      "vlc"
      "whatsapp"
      "zed"
    ];
    masApps = {
      "1Password for Safari" = 1569813296;
      "Infuse" = 1136220934;
      "Microsoft Excel" = 462058435;
      "Microsoft PowerPoint" = 462062816;
      "Microsoft Remote Desktop" = 1295203466;
      "Microsoft Word" = 462054704;
      "OneDrive" = 823766827;
      "Tailscale" = 1475387142;
    };
  };
}
