terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws",
        version = "~> 4.0"
    }
  }
  backend "s3" {
    bucket = "mybucket"
    key = "path/to/my/key"
    region = "us-east-1"
  }
}

# Configuration of AWS Provider
provider "aws" {
    region = "us-east-1"
}

# Configuration of VPC
resource "aws_vpc" "yf_vpc_example" {
  cidr_block = "25.0.0.0/16"
  tags = {
    Name = "yf-tf-vpc"
  }
}

# Configuration of public subnet
resource "aws_subnet" "yf_public_subnet" {
  vpc_id = aws_vpc.yf_vpc_example.id
  cidr_block = "25.0.1.0/24"
  tags = {
    Name = "yf-tf-public-1"
  }
  
}

# terraform destroy -> delete all the infraestructure created.



