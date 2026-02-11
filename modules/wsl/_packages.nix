{
  pkgs,
  inputs,
  ...
}: let
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in {
  environment.systemPackages = with pkgs; [
    # inspo: https://mynixos.com/nixpkgs/package/azure-cli
    (pkgs-unstable.azure-cli.withExtensions [
      pkgs-unstable.azure-cli.extensions.k8s-extension
      pkgs-unstable.azure-cli.extensions.amg
      pkgs-unstable.azure-cli.extensions.elastic-san
    ])
    k9s
    kubectl
    kubectl-cnpg
    kubectx
    kubelogin
    kubernetes-helm
    python315
    terraform
    trashy
  ];
}
