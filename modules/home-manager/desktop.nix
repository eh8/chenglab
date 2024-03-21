{pkgs, ...}: {
  programs.firefox.enable = true;
  programs.vscode.enable = true;

  home = {
    packages = with pkgs; [
      iosevka
      inter
    ];
  };
}
