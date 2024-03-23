{config, ...}: {
  # inspo: https://github.com/reckenrode/nixos-configs/blob/main/hosts/meteion/configuration.nix
  system.autoUpgrade = {
    enable = true;
    dates = "03:30";
    # randomizedDelaySec = "45min";
    flake = "github:eh8/chenglab";
  };
}
