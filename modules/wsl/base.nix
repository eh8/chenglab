{
  pkgs,
  vars,
  ...
}: {
  imports = [
    ./_packages.nix
  ];

  wsl = {
    enable = true;
    defaultUser = vars.userName;
    # note: disabled auto-generated resolv.conf since default dns results in helm failure
    wslConf.network.generateResolvConf = false;
  };

  nixpkgs.config.allowUnfree = true;
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
  };

  users.users.${vars.userName} = {
    isNormalUser = true;
    description = vars.userName;
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;
  security.sudo.wheelNeedsPassword = false;
  networking.nameservers = [
    "1.1.1.1"
    "1.0.0.1"
  ];
  services.vscode-server.enable = true;
  time.timeZone = "America/New_York";

  environment.systemPackages = [
    # inspo: https://github.com/croomes
    (pkgs.writeShellScriptBin "kubectl-enter" ''
            if [ -z "$1" ]; then
              echo "Please specify node name"
              exit 1
            fi

            NODE="$1"
            IMAGE="alpine"
            POD="nsenter-$(env LC_CTYPE=C tr -dc a-z0-9 < /dev/urandom | head -c 6)"
            NAMESPACE=""

            kubectl get node "$NODE" >/dev/null || exit 1

            OVERRIDES="$(
              cat <<EOT
      {
        "spec": {
          "nodeName": "$NODE",
          "hostPID": true,
          "containers": [
            {
              "securityContext": {
                "privileged": true
              },
              "image": "$IMAGE",
              "name": "nsenter",
              "stdin": true,
              "stdinOnce": true,
              "tty": true,
              "command": [ "nsenter", "--target", "1", "--mount", "--uts", "--ipc", "--net", "--pid", "--", "bash", "-l" ]
            }
          ]
        }
      }
      EOT
            )"

            echo "spawning \"$POD\" on \"$NODE\""
            kubectl run --namespace "$NAMESPACE" --rm --image "$IMAGE" --overrides="$OVERRIDES" -ti "$POD"
    '')
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
