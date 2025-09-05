resource "aws_iam_role" "cluster-role"{
  assume_role_policy = data.aws_iam_policy_document.policy_role
}
resource "aws_iam_role_policy" "autoscale-policy" {
  policy = file("${path.module}/autoscaling-policy.json")
  role   = aws_iam_role.eks-cluster-role.id
}