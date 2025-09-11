module "eks" {
source = "./module/eks"
subnet_id = module.VPC.backend
env                          = "dev"
vpc_id    = module.VPC.vpc_id
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
module "rds" {
  source                = "./module/rds"
  for_each              = var.rds
  allocated_storage     = each.value["allocated_storage"]
  component             = each.value["db_name"]
  engine                = each.value["engine"]
  engine_version        = each.value["engine_version"]
  env                   = var.env
  family                = each.value["family"]
  instance_class        = each.value["instance_class"]
  kms_key_id            = var.kms_key_id
  server_app_ports      = var.backendServers
  subnet_id             = module.VPC.db
  vpc_id                = module.VPC.vpc_id
  multi_az              = false
  publicly_accessible   = false
  skip_final_snapshot   = true
  storage_type          = true

}

# module "monitoring"{
#   source = "./module/monitoring"
# }




