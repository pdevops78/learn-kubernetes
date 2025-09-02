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

EOF
  }
}
# aws-auth upsert --maproles --rolearn arn:aws:iam::041445559784:role/workstattion_role --username system:node:{{EC2PrivateDNSName}} --groups system:masters
#  add dynamically ebs volume required add-on plugin
# resource "aws_eks_addon" "example" {
#   cluster_name = aws_eks_cluster.cluster.name
#   addon_name   = "vpc-cni"
#   resolve_conflicts_on_update = "OVERWRITE"
# }

#  install external-dns
# resource "helm_release" "external_dns" {
#   depends_on = [null_resource.aws-auth,aws_iam_role_policy.externaldns_node_policy]
#   name       = "external-dns-${var.env}"
#   namespace  = "default"
#   repository = "https://kubernetes-sigs.github.io/external-dns/"
#   chart      = "external-dns"
#   version    = "1.17.0"
# }

# eks addon is a pod identity agent to link both service account and iam role
# it is just like connection or enable or highlight which two links
resource "aws_eks_addon" "eks-pod-identity-agent" {
  depends_on                  = [aws_eks_node_group.node]
  cluster_name                = aws_eks_cluster.cluster.name
  addon_name                  = "eks-pod-identity-agent"
  addon_version               = "v1.3.2-eksbuild.2"
  resolve_conflicts_on_update = "OVERWRITE"
  resolve_conflicts_on_create = "OVERWRITE"
}

resource "aws_eks_pod_identity_association" "external--pod-association" {
  cluster_name    = aws_eks_cluster.cluster.name
  namespace       = "default"
  service_account = kubernetes_service_account.external_dns.metadata[0].name
  role_arn        = aws_iam_role.external_dns.arn
}


# helm install external-dns external-dns/external-dns --version 1.17.0 --namespace default --create-namespace
