{
  # inspo: https://github.com/reckenrode/nixos-configs/blob/main/hosts/meteion/configuration.nix
  system.autoUpgrade = {
    enable = true;
    dates = "*-*-* 07:00:00";
    randomizedDelaySec = "1h";
    flake = "github:eh8/chenglab";
  };
}
