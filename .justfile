default:
    just --list

deploy machine='' ip='':
    @if [ "$(uname)" = "Darwin" ] && [ -z "{{ machine }}" ] && [ -z "{{ ip }}" ]; then \
      sudo darwin-rebuild switch --flake .; \
    elif [ -z "{{ machine }}" ] && [ -z "{{ ip }}" ]; then \
      nixos-rebuild switch --use-remote-sudo --flake .; \
    elif [ -z "{{ ip }}" ]; then \
      nixos-rebuild switch --use-remote-sudo --flake ".#{{ machine }}"; \
    else \
      nixos-rebuild switch --fast --flake ".#{{ machine }}" --use-remote-sudo --target-host "eh8@{{ ip }}" --build-host "eh8@{{ ip }}"; \
    fi

up:
    nix flake update

lint:
    statix check .

fmt:
    nix fmt .     

gc:
    sudo nix-collect-garbage -d && nix-collect-garbage -d

repair:
    sudo nix-store --verify --check-contents --repair

sops-edit:
    sops secrets/secrets.yaml

sops-rotate:
    for file in secrets/*; do sops --rotate --in-place "$file"; done

sops-update:
    for file in secrets/*; do sops updatekeys "$file"; done

build-iso:
    nix build .#nixosConfigurations.iso1chng.config.system.build.isoImage
