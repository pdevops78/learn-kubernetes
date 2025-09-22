resource "aws_iam_role" "autoscaling_role" {
  name               = "autoscaling-role"
  assume_role_policy = data.aws_iam_policy_document.policy_role.json
}

resource "aws_iam_role_policy" "autoscaling_policy" {
  name = "autoscaling-policy"
  role = aws_iam_role.autoscaling_role.id
  policy = file("${path.module}/autoscaling-policy.json")
}

resource "aws_eks_addon" "autoscaling_pod_identity_agent" {
  depends_on                  = [aws_eks_node_group.node]
  cluster_name                = aws_eks_cluster.cluster.name
  service_account_role_arn    = aws_iam_role.autoscaling_role.arn
  addon_name                  = "eks-pod-identity-agent"
  addon_version               = "v1.3.2-eksbuild.2"
  resolve_conflicts_on_update = "OVERWRITE"
  resolve_conflicts_on_create = "OVERWRITE"
}

resource "helm_release" "autoscaler" {

  name       = "eks"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  version    = "9.50.1"
  namespace  = "kube-system"
  set {
    name  = "autoDiscovery.clusterName"
    value = eks
  }
}