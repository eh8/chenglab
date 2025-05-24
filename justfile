default:
  just --list

deploy machine ip='':
  #!/usr/bin/env sh
  if [ {{machine}} = "macos" ]; then
    sudo darwin-rebuild switch --flake .
  elif [ -z "{{ip}}" ]; then
    sudo nixos-rebuild switch --fast --flake ".#{{machine}}"
  else
    nixos-rebuild switch --fast --flake ".#{{machine}}" --use-remote-sudo --target-host "eh8@{{ip}}" --build-host "eh8@{{ip}}"
  fi

up:
  nix flake update

lint:
  statix check .

gc:
  sudo nix-collect-garbage -d && nix-collect-garbage -d

repair:
  sudo nix-store --verify --check-contents --repair

sopsedit:
  sops secrets/secrets.yaml

sopsrotate:
  for file in secrets/*; do sops --rotate --in-place "$file"; done
  
sopsupdate:
  for file in secrets/*; do sops updatekeys "$file"; done

buildiso:
  nix build .#nixosConfigurations.iso1chng.config.system.build.isoImage