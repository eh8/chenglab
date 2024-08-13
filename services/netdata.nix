{
  config,
  pkgs,
  ...
}: {
  sops.secrets."netdata-token" = {};

  services.netdata = {
    enable = true;
    # inspo: https://github.com/NixOS/nixpkgs/issues/277748
    package = pkgs.netdata.override {withCloud = true;};
    claimTokenFile = config.sops.secrets."netdata-token".path;
  };

  environment.persistence."/nix/persist" = {
    directories = [
      "/var/lib/netdata"
    ];
  };
}
