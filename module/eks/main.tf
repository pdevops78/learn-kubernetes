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
resource "null_resource" "aws-auth" {
  depends_on = [aws_eks_node_group.node]
  provisioner "local-exec" {
    command = <<EOF
    aws eks update-kubeconfig --name "eks-cluster-${var.env}"
    aws-auth upsert --maproles --rolearn arn:aws:iam::041445559784:role/workstattion_role --username system:node:{{EC2PrivateDNSName}} --groups system:masters
EOF
  }
}
# create service account in eks
resource "kubernetes_service_account" "external_dns-sa" {
  metadata {
    name      = "dns-sa"
    namespace = "default"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.external-dns.arn
    }
  }
}

# install external-dns through helm-chart
resource "helm_release" "external_dns" {
  depends_on       = [aws_eks_cluster.cluster,aws_eks_node_group.node]
  name             = "external-dns"
  repository       = " https://kubernetes-sigs.github.io/external-dns/"
  chart            = "external-dns"
  namespace        = "default"
  version          = "1.18.0"
  create_namespace = false
  set {
    name  = "provider"
    value = "aws"
  }
  set {
    name  = "serviceAccount.create"
    value = false
  }
  set {
    name  = "serviceAccount.name"
    value = "dns-sa"
  }

}

#  install prometheus
resource "helm_release" "kube_prometheus_stack" {
  depends_on       = [aws_eks_cluster.cluster,aws_eks_node_group.node]
  name             = "kube-prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = "default"
  version          = "57.0.3"
  create_namespace = false
}

#  install autoscaling group

resource "helm_release" "cluster_autoscaler" {
  depends_on = [aws_eks_cluster.cluster, aws_eks_node_group.node]
  name       = "cluster-autoscaler"
  repository = " https://kubernetes.github.io/autoscaler"
  namespace  = "default"
  chart      = "cluster-autoscaler"
  version    = "9.29.1"
}









