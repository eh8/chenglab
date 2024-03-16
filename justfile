default:
  just --list

deploy machine ip='':
  #!/usr/bin/env sh
  if [ {{machine}} = "macos" ]; then
    darwin-rebuild switch --flake .
  elif [ -z "{{ip}}" ]; then
    sudo nixos-rebuild switch --fast --flake ".#{{machine}}"
  else
    nixos-rebuild switch --fast --flake ".#{{machine}}" --use-remote-sudo --target-host "eh8@{{ip}}" --build-host "eh8@{{ip}}"
  fi

up:
  nix flake update

history:
  nix profile history --profile /nix/var/nix/profiles/system

clean:
  sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d

gc:
  sudo nix-collect-garbage --delete-old

repair:
  sudo nix-store --verify --check-contents --repair

edit-secrets:
  sops secrets/secrets.yaml

rotate-secrets:
  for file in secrets/*; do sops --rotate --in-place "$file"; done
  
sync-secrets:
  for file in secrets/*; do sops updatekeys "$file"; done

build-iso:
  nix build .#nixosConfigurations.iso1chng.config.system.build.isoImage