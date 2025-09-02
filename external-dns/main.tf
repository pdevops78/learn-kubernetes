resource "helm_release" "external_dns" {
  name       = "external-dns"
  namespace  = "kube-system"
  repository = "https://kubernetes-sigs.github.io/external-dns/"
  chart      = "external-dns"
  set {
    name  = "serviceAccount.name"
    value = "dns-sa"

  }
}

