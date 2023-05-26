variable "vpc_id" {
  description = "ID of the VPC where EC2 instances will be launched"
}

variable "project_name" {
  description = "Project Name"
}

variable "ami" {
  description = "AMI ID"
  validation {
    condition     = length(var.ami) > 4 && substr(var.ami, 0, 4) == "ami-"
    error_message = "The image_id value must be a valid AMI id, starting with \"ami-\"."
  }
}

variable "instance_type" {
  description = "Type of the instance"
}

variable "disk_size" {
  type        = number
  description = "Disk size in GB"
  validation {
    condition     = var.disk_size >= 8
    error_message = "The disk_size has to be grater than 8GB"
  }
}
