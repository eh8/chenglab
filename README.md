<p align="center">
<a href="https://nixos.org"><img src="https://img.shields.io/badge/NixOS-unstable-blue.svg?style=flat-square&logo=NixOS&logoColor=white" alt="nixos unstable"></a>
<br>
<img src=".github/images/background.gif" width=500 alt="chenglab" />
<img src=".github/images/servers.jpg" width=500 alt="chenglab" />
<br>
Homelab hardware: ThinkCenter M710q Tiny, Intel i5-7500T and 8GB RAM
</p>

## Highlights

These are the Nix/NixOS configurations for my homelab servers, desktop, and 
M1 MacBook Air 

- ❄️ Nix flakes handle upstream dependencies, tracks unstable channel of Nixpkgs
- 🏠 [home-manager](https://github.com/nix-community/home-manager) manages
  dotfiles 
- 🍎 [nix-darwin](https://github.com/LnL7/nix-darwin) manages MacBook 
- 🤫 [sops-nix](https://github.com/Mic92/sops-nix) manages secrets 
- 🔑 Remote initrd unlock system to decrypt drives on boot 
- 🌬️ Root on tmpfs aka impermanence 
- 🔒 Automatic Let's Encrypt certificate registration and renewal 
- 🧩 Tailscale, Nextcloud, Jellyfin, Homebridge, Scrypted, among other nice
  self-hosted applications 
- ⚡️ `justfile` contains useful aliases for many frequent and atrociously long
  `nix` commands 
- 🤖 `flake.lock` updated daily via GitHub Action, servers are configured to
  automatically upgrade daily via `modules/nixos/auto-update.nix`
- 🧱 Modular architecture promotes readability for me and copy-and-paste-ability
  for you 

## Getting started

> [!IMPORTANT] 
> You'll need to run this script as sudo or have sudo permissions.

> [!WARNING] 
> This script is primarily meant for my own use. Using it to install NixOS on
> your own hardware will fail. At minimum, you'll need to do the following
> before attemping installation:
> 
> 1. Create a configuration for your own device in the `machines/` folder
> 1. Retool your own sops-nix secrets or remove them entirely if you don't use
>    sops-nix
> 1. Add an entry to flake.nix referencing the configuration created in step 1

```
bash -c "$(curl -fsSL https://raw.githubusercontent.com/eh8/chenglab/main/install.sh)"
```

On macOS, this script will install `nix` using the [Determinate Systems Nix
installer](https://zero-to-nix.com/start/install) and prompt you to install my
configuration.

On Linux, *running this script from the NixOS installation ISO* will prepare
your system for NixOS by partitioning drives and mounting them. 

> [!TIP] 
> When installing NixOS onto a headless local server, place your own
> custom NixOS ISO file onto a USB drive with Ventoy. Ventoy can automatically
> load the NixOS ISO file, and you can enable connectivity by building your own
> custom ISO with your own personal SSH key.

## Useful commands 🛠️

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

Make sure each machine's public key is listed as entry in `.sops.yaml`. To
modify `secrets/secrets.yaml`:

```
just secrets-edit
```

### Syncing sops keys for a new machine 

```
just secrets-sync
```

## Important caveats

### Changing user passwords

To modify user password, first generate a hash

```
echo "password" | mkpasswd -m SHA-512 -s
```

Then run `just edit-secrets` to replace the existing decrypted hash with the one
that you just generated. If you use a password manager, sure to update the new
password as necessary.

### Changing SSH keys

Make sure you update the public key as it appears across the repository.

### Installation source

Make sure the Determinate Nix installer one-liner in `install.sh` is consistent
with how it appears on the official website.

## To-do

1. [Secure boot](https://github.com/nix-community/lanzaboote)
2. Write up explanatory blog post
3. Implement binary caching
4. [Wireless remote
   unlocking](https://discourse.nixos.org/t/wireless-connection-within-initrd/38317/13)


## Frequently used resources

- [Search NixOS options](https://search.nixos.org/options)
- [Home Manager Option
  Search](https://mipmip.github.io/home-manager-option-search/)
- [Darwin Configuration
  Options](https://daiderd.com/nix-darwin/manual/index.html)

## Helpful references

- [An outstanding beginner friendly introduction to NixOS and
  flakes](https://nixos-and-flakes.thiscute.world/)
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
- [Dealing with post nix-flake god
  complex](https://www.reddit.com/r/NixOS/comments/kauf1m/dealing_with_post_nixflake_god_complex/)
