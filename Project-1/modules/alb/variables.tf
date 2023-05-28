# ALB Variables
variable "project_name" {
  description = "Project Name"
}

variable "vpc_id" {
  description = "ID of the VPC where EC2 instances will be launched"
}

variable "ecs_sg" {
  description = "ID of ECS security group"
}

variable "subnets" {
  type = list(string)
}

variable "acm_certificate" {
  description = "Arn of ACM certificate"
}
