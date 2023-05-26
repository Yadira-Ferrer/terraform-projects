# To invoke modules
module "vpc" {
  source   = "./modules/network"
  vpc_cidr = var.vpc_module["vpc_cidr"]
}

module "launch_template" {
  source        = "./modules/launch_template"
  vpc_id        = module.vpc.vpc_id
  instance_type = var.launch_template_module["instance_type"]
  disk_size     = var.launch_template_module["disk_size"]
  ami           = var.launch_template_module["ami"]
  project_name  = var.project_name
}

# terraform apply -var-file="variables/input.tfvars"
