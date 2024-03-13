{...}: {
  boot.initrd.luks.devices."fun".device = "/dev/sda1";
  boot.initrd.luks.reusePassphrases = true;

  fileSystems."/fun" = {
    device = "/dev/disk/by-label/fun";
    fsType = "ext4";
  };
}
