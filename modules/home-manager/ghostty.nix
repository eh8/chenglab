{pkgs, ...}: {
  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty-bin;
    enableZshIntegration = true;
    settings = {
      theme = "GitHub Dark Default";
      cursor-style = "block";
      shell-integration-features = "no-cursor";

      font-family = "Iosevka Medium";
      font-size =
        if pkgs.stdenv.isDarwin
        then 15
        else 12;

      window-width = 120;
      window-height = 24;
      window-padding-x = 30;
      window-padding-y = 30;
      window-padding-balance = true;
    };
  };
}
