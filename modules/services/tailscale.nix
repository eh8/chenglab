{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    tailscale
  ];

  services.tailscale = {
    enable = true;
    openFirewall = true;
  };

  fileSystems."/var/lib/tailscale" = {
    device = "/nix/persist/var/lib/tailscale";
    fsType = "none";
    options = [ "bind" ];
  };
}
