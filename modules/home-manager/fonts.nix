{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      # fonts
      inter
      nerdfonts
    ];
  };
}
