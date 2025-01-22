provider "aws" {
  region = "us-east-1"
}

module "network" {
  source = "./modules/network"
}

module "security" {
  source = "./modules/security"
  vpc_id = module.network.vpc_id
}

module "compute" {
  source       = "./modules/compute"
  vpc_id       = module.network.vpc_id
  subnet_ids   = module.network.subnet_ids
  security_ids = module.security.security_group_ids
  mean_app_ami = var.mean_app_ami
  mongodb_ami  = var.mongodb_ami
}

module "lb" {
  source               = "./modules/lb"
  vpc_id               = module.network.vpc_id
  subnet_ids           = module.network.subnet_ids
  security_ids         = module.security.security_group_ids
  mean_app_instance_id = module.compute.mean_app_id
}
