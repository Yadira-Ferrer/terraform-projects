variable "project_name" {
  type = string
}

variable "vpc_module" {
  description = "Set of variables for VPC module"
}

variable "launch_template_module" {
  description = "Set of variables for Launch Template"
}

variable "route53_module" {
  description = "Set of variable for Route53"
}
