{
  config,
  vars,
  ...
}: {
  boot.kernelParams = ["ip=dhcp"];
  boot.initrd.network = {
    enable = true;
    ssh = {
      enable = true;
      shell = "/bin/cryptsetup-askpass";
      authorizedKeys = config.users.users.${vars.userName}.openssh.authorizedKeys.keys;
      hostKeys = ["/nix/secret/initrd/ssh_host_ed25519_key"];
    };
  };
}
