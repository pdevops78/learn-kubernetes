module "eks" {
source = "./module/eks"
subnet_id = module.VPC.backend
env                          = "dev"
vpc_id    = module.VPC.vpc_id
instance_type = "t3.medium"
}

module "VPC"{
source                       = "./module/VPC"
env                          = var.env
vpc_cidr_block               = var.vpc_cidr_block
frontendServers              = var.frontendServers
availability_zone            = var.availability_zone
default_vpc_id               = var.default_vpc_id
default_vpc_cidr_block       = var.default_vpc_cidr_block
default_vpc_route_table_id   = var.default_vpc_route_table_id
publicServers                = var.publicServers
dbServers                    = var.dbServers
backendServers               = var.backendServers
}
