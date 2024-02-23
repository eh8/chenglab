default:
  just --list

deploy machine ip:
  nixos-rebuild switch --fast --flake ".#{{machine}}" --use-remote-sudo --target-host "eh8@{{ip}}" --build-host "eh8@{{ip}}"
