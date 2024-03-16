{pkgs, ...}: {
  programs.firefox.enable = true;
  programs.vscode.enable = true;

  home = {
    username = "eh8";
    packages = with pkgs; [
      iosevka
      inter
    ];
  };
}
