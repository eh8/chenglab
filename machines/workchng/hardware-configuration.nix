{lib, ...}: {
  nixpkgs.hostPlatform = lib.mkDefault "aarch64-darwin";
}
