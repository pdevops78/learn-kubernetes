
resource "aws_iam_role" "external-dns" {
  name               = "eks-pod-identity-external-dns"
  assume_role_policy = data.aws_iam_policy_document.policy_role.json
  #   the above assume_role_policy is a trust relationships
}
resource "aws_iam_role_policy" "external_dns_policy" {
  name = "external-dns"
  role = aws_iam_role.external-dns.id
  policy = file("${path.module}/policy-external-dns.json")
  #   attach policy-external-dns.json to external-dns
}


resource "aws_iam_role" "ebs-dns" {
  name               = "ebs-csi-driver"
  assume_role_policy = data.aws_iam_policy_document.policy_role.json
  #   the above assume_role_policy is a trust relationships
}

resource "aws_iam_role_policy" "ebs_dns_policy" {
  name = "ebs-csi"
  role = aws_iam_role.ebs-dns.id
  policy = file("${path.module}/ebs-policy.json")
}