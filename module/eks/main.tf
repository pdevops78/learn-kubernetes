resource "aws_eks_cluster" "example" {
  name = "example"
 role_arn = aws_iam_role.cluster.arn
  vpc_config {
    subnet_ids = [
      aws_subnet.az1.id,
      aws_subnet.az2.id,
      aws_subnet.az3.id,
    ]
  }
}