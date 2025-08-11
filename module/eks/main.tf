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

 resource "aws_launch_template" "template" {
   name = "${var.env}-lt"
   image_id = data.aws_ami.ami.id
   instance_type = var.instance_type
   vpc_security_group_ids= [aws_security_group.sg.id]
   #  to encrypt the disk by using kms key id
#  root_block_device {
#      encrypted    = true
# #      kms_key_id   = var.kms_key_id
# #      volume_type  = var.volume_type
#      }
   tags = {
   Name = "${var.env}-lt"
   }
  }


resource "aws_security_group" "alb_sg" {
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
     Name = "${var.env}-alb"
   }
  }