{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      inter
      nerdfonts
    ];
  };
}
