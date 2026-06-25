{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    efibootmgr
    git
    gptfdisk
    # inspo: https://github.com/ghostty-org/ghostty/discussions/5753#discussioncomment-12197678
    ghostty.terminfo
    parted
    ventoy
    vim
  ];

  # temp
  # inspo: https://github.com/ventoy/Ventoy/issues/3224
  nixpkgs.config.permittedInsecurePackages = [
    "ventoy-1.1.12"
  ];
}
