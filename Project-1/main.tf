# To invoke modules
module "vpc" {
  source   = "./modules/network"
  vpc_cidr = var.vpc_module["vpc_cidr"]
}

module "alb" {
  source          = "./modules/alb"
  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.public_subnets
  acm_certificate = module.route53.acm_cert_validation
  project_name    = var.project_name
}

module "launch_template" {
  source        = "./modules/launch_template"
  vpc_id        = module.vpc.vpc_id
  efs_dns       = module.efs.efs_dns
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

module "route53" {
  source       = "./modules/route53"
  alb_dns      = module.alb.alb_dns
  alb_zone_id  = module.alb.alb_zone_id
  zone_id      = var.route53_module["zone_id"]
  project_name = var.project_name
}

module "efs" {
  source          = "./modules/efs"
  subnets         = module.vpc.private_subnets
  ec2_sg          = module.launch_template.ec2_sg
  ec2_private_key = module.launch_template.private_key
  project_name    = var.project_name
}

# terraform apply -var-file="variables/input.tfvars"
