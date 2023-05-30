variable "vpc_cidr" {
  description = "Definition of CIDR block"
}

variable "azs" {
  type        = list(string)
  description = "Availability Zones"
  default     = ["us-west-1b", "us-west-1c"]
}
