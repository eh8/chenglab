{lib, ...}: {
  networking.networkmanager.enable = lib.mkForce false;
  services.openssh.settings.PermitRootLogin = lib.mkForce "yes";
}
