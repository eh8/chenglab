default:
  just --list

deploy:
  sudo nixos-rebuild switch --flake .