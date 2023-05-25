# To invoke modules
module "vpc" {
  source   = "./modules/network"
  vpc_cidr = var.vpc_module["vpc_cidr"]
}

# terraform apply -var-file="variables/input.tfvars"