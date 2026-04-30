{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      inter
      iosevka
    ];
  };
}
