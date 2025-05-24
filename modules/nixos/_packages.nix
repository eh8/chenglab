{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    efibootmgr
    git
    gptfdisk
    parted
    ventoy
    vim
  ];

  # temp
  # inspo: https://github.com/ventoy/Ventoy/issues/3224
  nixpkgs.config.permittedInsecurePackages = [
    "ventoy-1.1.05"
  ];
}
