# Route53 Variables

variable "project_name" {
  description = "Project Name"
}

variable "zone_id" {
  description = "ID of hosted zone"
}

variable "alb_dns" {
  description = "ALB DNS name."
}

variable "alb_zone_id" {
  description = "ALB zone id"
}
