{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # inspo: https://mynixos.com/nixpkgs/package/azure-cli
    (azure-cli.withExtensions [
      azure-cli.extensions.k8s-extension
      azure-cli.extensions.aks-preview
      azure-cli.extensions.amg
    ])
    k9s
    kubectl
    kubectl-cnpg
    kubernetes-helm
    terraform
    trashy
  ];
}
