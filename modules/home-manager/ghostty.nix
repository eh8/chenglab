{
  lib,
  pkgs,
  ...
}: {
  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty-bin;
    enableZshIntegration = true;
    settings = lib.mkMerge [
      {
        theme = "GitHub Dark Default";
        cursor-style = "block";
        shell-integration-features = "no-cursor";

        font-family = "Iosevka Medium";
        font-size = lib.mkMerge [
          (lib.mkIf pkgs.stdenv.isLinux 12)
          (lib.mkIf pkgs.stdenv.isDarwin 15)
        ];

        window-width = 120;
        window-height = 24;
        window-padding-x = 30;
        window-padding-y = 30;
        window-padding-balance = true;
      }
    ];
  };
}
