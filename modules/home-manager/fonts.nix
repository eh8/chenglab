{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      inter
      iosevka
      fira-code
    ];
  };
}
