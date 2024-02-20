default: deploy

deploy:
  sudo nixos-rebuild switch --flake .