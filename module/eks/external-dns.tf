resource "helm_release" "external-dns" {
  depends_on = [null_resource.aws-auth,aws_iam_role_policy.external_dns_policy]
  name       = "external-dns"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"
  version    = "9.0.3"
  namespace = "default"
  create_namespace = true
  set {
    name  = "serviceAccount.name"
    value = "dns-sa"
  }
  set {
    name  = "serviceAccount.create"
    value = "false"
  }
}

# #  create pod identity and  attach to cluster
resource "aws_eks_pod_identity_association" "external--pod-association" {
  cluster_name    = aws_eks_cluster.cluster.name
  namespace       = "default"
  service_account = "dns-sa"
  role_arn        = aws_iam_role.external-dns.arn
}

resource "aws_eks_addon" "eks-pod-identity-agent" {
  depends_on                  = [aws_eks_node_group.node]
  cluster_name                = aws_eks_cluster.cluster.name
  addon_name                  = "eks-pod-identity-agent"
  addon_version               = "v1.3.2-eksbuild.2"
  resolve_conflicts_on_update = "OVERWRITE"
  resolve_conflicts_on_create = "OVERWRITE"
}


