# homelab

## Getting set up 

You'll want to install `nix` onto your local machine if you don't already use it. I prefer the [Determine Nix installer](https://zero-to-nix.com/start/install).

## Useful commands

Install `just` to access the simple aliases below

### Remote deployment

To remotely deploy `MACHINE`, which has an IP address of `10.0.10.2`

```
just deploy MACHINE 10.0.10.2
```

### Edit secrets

To modify `secrets/secrets.yaml`. Make sure each device public key is listed as entry in `.sops.yaml`.

```
just secrets
```

## Important caveats

### Changing user passwords

To modify user password, first generate a hash

```
echo "password" | mkpasswd -m SHA-512 -s
```

Then run `just secrets` to replace the existing decrypted hash with the one that you just generated. If you use a password manager, sure to update the new password as necessary.

## To-do

1. [Wireless remote unlocking](https://discourse.nixos.org/t/wireless-connection-within-initrd/38317/13)

## Helpful references

- [NixOS on Hetzner Dedicated](https://mhu.dev/posts/2024-01-06-nixos-on-hetzner)
- [NixOS ❄: tmpfs as root](https://elis.nu/blog/2020/05/nixos-tmpfs-as-root)
- [Handling Secrets in NixOS: An Overview](https://lgug2z.com/articles/handling-secrets-in-nixos-an-overview/)