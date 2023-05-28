variable "lc_id" {
}

variable "subnets" {
  type = list(string)
}

variable "project_name" {
  description = "Project Name"
}

variable "alb_id" {
  description = "ID of the Application Load Balancer."
}

variable "tg_arn" {
  description = "ARN of the Target Group"
}
