resource "aws_eks_cluster" "cluster" {
  name = "eks-cluster-${var.env}"
 role_arn = aws_iam_role.eks-cluster-role.arn
  vpc_config {
    subnet_ids = var.subnet_id
  }
 }

 resource "aws_eks_node_group" "node" {
   cluster_name    = aws_eks_cluster.cluster.name
   node_group_name = "eks-node-${var.env}"
   node_role_arn   = aws_iam_role.node-role.arn
   subnet_ids      =  var.subnet_id
   capacity_type   = "SPOT"
   instance_types  = ["t3.medium"]
     launch_template {
       name    = "eks-${var.env}"
       version = "$Latest"
     }
   scaling_config {
     desired_size = 1
     max_size     = 2
     min_size     = 1
   }
   update_config {
     max_unavailable = 1
   }
 }

 //arn:aws:iam::041445559784:role/eks-cluster-example

resource "aws_launch_template" "main" {
  name = "eks-${var.env}"
  device_name = "/dev/xvda"

#   ebs {
#     volume_size           = 100
#     encrypted             = true
#     kms_key_id            = var.kms_key_id
#     delete_on_termination = true
#   }
}
  tag_specifications {
    resource_type = "instance"
    tags = {
      "Name" = "${aws_eks_cluster.cluster.name}-workernode"
    }
  }


resource "null_resource" "aws-auth" {
  depends_on = [aws_eks_node_group.node]
  provisioner "local-exec" {
    command = <<EOF
    aws eks update-kubeconfig --name "eks-cluster-${var.env}"
    aws-auth upsert --maproles --rolearn arn:aws:iam::041445559784:role/workstattion_role --username system:node:{{EC2PrivateDNSName}} --groups system:masters
EOF
  }
}








