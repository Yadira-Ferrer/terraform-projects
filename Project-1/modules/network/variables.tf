variable "vpc_cidr" {
  description = "Definition of CIDR block"
}

variable "azs" {
  type        = list(string)
  description = "Availability Zones"
  default     = ["us-west-2b", "us-west-2c"]
}
