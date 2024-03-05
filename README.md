[![NixOS Unstable](https://img.shields.io/badge/NixOS-unstable-blue.svg?style=flat-square&logo=NixOS&logoColor=white)](https://nixos.org)

# Chenglab

<p align="center">
<span><img src=".github/background-1.png" height="100" /></span>
<span><img src=".github/background-2.png" height="100" /></span>
<span><img src=".github/background-3.png" height="100" /></span>
</p>
<p align="center">
<i>it’s not just a homelab, it’s a chenglab™<i>
</p>

## Getting set up 

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/eh8/chenglab/main/install.sh)"
```

On macOS, this will prompt you to install `nix` onto your local machine if you
don't already use it. I prefer the [Determine Nix
installer](https://zero-to-nix.com/start/install). On Linux, it will prepare
your system by partitioning drives and mounting them.

> Be sure to carefully and fully examine this repository before deploying on
> your own systems!

## Useful commands

Install `just` to access the simple aliases below

### Locally deploy changes

```
just deploy macos
```

```
just deploy MACHINE
```

### Remote deployment

To remotely deploy `MACHINE`, which has an IP address of `10.0.10.2`

```
just deploy MACHINE 10.0.10.2
```

### Edit secrets

To modify `secrets/secrets.yaml`. Make sure each device public key is listed as
entry in `.sops.yaml`.

```
just secrets
```

## Important caveats

### Changing user passwords

To modify user password, first generate a hash

```
echo "password" | mkpasswd -m SHA-512 -s
```

Then run `just secrets` to replace the existing decrypted hash with the one that
you just generated. If you use a password manager, sure to update the new
password as necessary.

### Changing SSH keys

Make sure you update the public key as it appears across the repository.

### Installation source

Make sure the Determinate Nix installer one-liner in `install.sh` is consistent
with how it appears on the official website.

## To-do

1. [Wireless remote
   unlocking](https://discourse.nixos.org/t/wireless-connection-within-initrd/38317/13)

## Frequently used resources

- [Search NixOS options](https://search.nixos.org/options)
- [Home Manager Option
  Search](https://mipmip.github.io/home-manager-option-search/)
- [Darwin Configuration
  Options](https://daiderd.com/nix-darwin/manual/index.html)

## Helpful references

- [Conditional
  implementation](https://nixos.wiki/wiki/Extend_NixOS#Conditional_Implementation)
- [Error when using lib.mkIf and lib.mkMerge to set configuration based on
  hostname](https://stackoverflow.com/questions/77527439/error-when-using-lib-mkif-and-lib-mkmerge-to-set-configuration-based-on-hostname)
- [Handling Secrets in NixOS: An
  Overview](https://lgug2z.com/articles/handling-secrets-in-nixos-an-overview/)
- [NixOS ❄: tmpfs as root](https://elis.nu/blog/2020/05/nixos-tmpfs-as-root)
- [NixOS on Hetzner
  Dedicated](https://mhu.dev/posts/2024-01-06-nixos-on-hetzner)
- [Setting up Nix on macOS](https://nixcademy.com/2024/01/15/nix-on-macos/)
- [Users.users.<name>.packages vs home-manager
  packages](https://discourse.nixos.org/t/users-users-name-packages-vs-home-manager-packages/22240)
- [Declaratively manage dock via
  nix](https://github.com/dustinlyons/nixos-config/blob/8a14e1f0da074b3f9060e8c822164d922bfeec29/modules/darwin/home-manager.nix#L74)