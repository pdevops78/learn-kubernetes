resource "aws_iam_role" "ebs_csi_driver" {
    name               = "ebs-csi-driver"
    assume_role_policy = data.aws_iam_policy_document.policy_role.json
}

resource "aws_iam_role_policy" "ebs_csi_policy" {
    name = "ebs-csi"
    role = aws_iam_role.ebs_csi_driver.id
    policy = file("${path.module}/ebs-policy.json")
}

resource "aws_eks_addon"  "eks_ebs_csi_driver" {
    depends_on                  = [aws_eks_node_group.node]
    cluster_name                = aws_eks_cluster.cluster.name
    addon_name                  = "aws-ebs-csi-driver"
    service_account_role_arn    = aws_iam_role.ebs_csi_driver.arn
    addon_version               = "v1.48.0-eksbuild.2"
    resolve_conflicts_on_update = "OVERWRITE"
    resolve_conflicts_on_create = "OVERWRITE"
  }




