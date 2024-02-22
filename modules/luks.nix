{
  config,
  pkgs,
  ...
}: {
  boot.kernelParams = ["ip=dhcp"];
  boot.initrd.network = {
    enable = true;
    ssh = {
      enable = true;
      port = 22;
      shell = "/bin/cryptsetup-askpass";
      authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIkcgwjYMHqUDnx0JIOSXQ/TN80KEaFvvUWA2qH1AHFC"  
      ];
      hostKeys = ["/etc/secrets/initrd/ssh_host_rsa_key"];
    };
  };
}
