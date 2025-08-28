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
  tag_specifications {
    resource_type = "instance"
    tags = {
      "Name" = "${aws_eks_cluster.cluster.name}-workernode"
    }
  }
}


resource "aws_security_group" "sg" {
  name                 =    "${var.env}-sg"
  description          =    "Allow TLS inbound traffic and all outbound traffic"
  vpc_id               =    var.vpc_id
   ingress {
      from_port        =     0
      to_port          =     0
      protocol         =    "-1"
      cidr_blocks      =    ["0.0.0.0/0"]
     }
   egress {
      from_port        =     0
      to_port          =     0
      protocol         =    "-1"
      cidr_blocks      =    ["0.0.0.0/0"]
     }
  tags = {
     Name = "${var.env}-lt"
   }
  }

#  add dynamically ebs volume required add-on plugin
# resource "aws_eks_addon" "example" {
#   cluster_name = aws_eks_cluster.cluster.name
#   addon_name   = "vpc-cni"
#   resolve_conflicts_on_update = "OVERWRITE"
# }

# install prometheus through helm chart
resource "helm_release" "prometheus" {
  name       = "prometheus"
  namespace  = "argocd"
  chart      = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  create_namespace = true
  values = [
    file("prometheus-values.yaml") # Optional custom values
  ]
}