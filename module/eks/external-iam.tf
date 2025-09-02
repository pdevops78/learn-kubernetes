# data "aws_iam_policy_document" "external_role" {
#   statement {
#     effect = "Allow"
#
#     principals {
#       type        = "Service"
#       identifiers = ["pods.eks.amazonaws.com"]
#     }
#
#     actions = [
#       "sts:AssumeRole",
#       "sts:TagSession"
#     ]
#   }
# }
# # Create the Kubernetes Service Account annotated with the IAM role
resource "kubernetes_service_account" "eks_sa" {
  metadata {
    name      = "external-dns"
    namespace = "argocd"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.external-dns.arn
    }
  }
}
# resource "aws_iam_role" "external_dns" {
#   name = "external-dns"
#   assume_role_policy = data.aws_iam_policy_document.external_role.json
# }
#
# resource "aws_iam_role_policy" "externaldns_node_policy" {
#   name = "external-dns-role-policy"
#   role = aws_iam_role.external_dns.id
#
#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect = "Allow",
#         Action = [
#           "route53:ChangeResourceRecordSets"
#         ],
#         Resource = "arn:aws:route53:::hostedzone/*"
#       },
#       {
#         Effect = "Allow",
#         Action = [
#           "route53:ListHostedZones",
#           "route53:ListResourceRecordSets",
#           "route53:ListTagsForResource"
#         ],
#         Resource = "*"
#       }
#     ]
#   })
# }
#
