# To invoke modules
module "vpc" {
  source   = "./modules/network"
  vpc_cidr = var.vpc_module["vpc_cidr"]
}

module "alb" {
  source       = "./modules/alb"
  vpc_id       = module.vpc.vpc_id
  ecs_sg       = module.launch_template.ecs_sg
  subnets      = module.vpc.public_subnets
  project_name = var.project_name
}

module "launch_template" {
  source        = "./modules/launch_template"
  vpc_id        = module.vpc.vpc_id
  instance_type = var.launch_template_module["instance_type"]
  disk_size     = var.launch_template_module["disk_size"]
  ami           = var.launch_template_module["ami"]
  project_name  = var.project_name
}

module "asg" {
  source       = "./modules/asg"
  lc_id        = module.launch_template.lc_id
  alb_id       = module.alb.alb_id
  tg_arn       = module.alb.target_group_arns
  subnets      = module.vpc.private_subnets
  project_name = var.project_name
}

# terraform apply -var-file="variables/input.tfvars"
