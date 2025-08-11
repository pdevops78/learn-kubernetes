resource "aws_eks_cluster" "cluster" {
  name = "eks-cluster-${var.env}"
 role_arn = aws_iam_role.eks-cluster-role.arn
  vpc_config {
    subnet_ids = var.subnet_id
  }
 }

 resource "aws_eks_node_group" "node" {
   cluster_name    = aws_eks_cluster.node-role.name
   node_group_name = "eks-node-${var.env}"
   node_role_arn   = aws_iam_role.node-role.arn
   subnet_ids      =  var.subnet_id

   scaling_config {
     desired_size = 1
     max_size     = 2
     min_size     = 1
   }

   update_config {
     max_unavailable = 1
   }

 }