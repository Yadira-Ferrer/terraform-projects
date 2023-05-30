# EFS Variables
variable "project_name" {
  description = "Project Name"
}

variable "subnets" {
  type = list(string)
}

variable "ec2_sg" {
  description = "EC2 security group id"
}

variable "ec2_private_key" {
  description = "EC2 private key pem"
}
