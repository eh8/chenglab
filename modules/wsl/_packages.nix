{
  pkgs,
  inputs,
  ...
}: let
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = pkgs.system;
    config.allowUnfree = true;
  };
in {
  environment.systemPackages = with pkgs; [
    # inspo: https://mynixos.com/nixpkgs/package/azure-cli
    (pkgs-unstable.azure-cli.withExtensions [
      pkgs-unstable.azure-cli.extensions.k8s-extension
      pkgs-unstable.azure-cli.extensions.aks-preview
      pkgs-unstable.azure-cli.extensions.amg
    ])
    k9s
    kubectl
    kubectl-cnpg
    kubectx
    kubernetes-helm
    terraform
    trashy
  ];
}