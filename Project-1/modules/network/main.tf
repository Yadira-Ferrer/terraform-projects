# Define 'Locals' to Tag my resources
locals {
  tags = {
    Owner = "Yadira"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

# VPC definition
resource "aws_vpc" "vpc_yf" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags                 = merge(local.tags, { Name = "vpc-yf" })
}

# SUBNETS definitions
resource "aws_subnet" "public_yf" {
  count             = 2
  vpc_id            = aws_vpc.vpc_yf.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone = element(var.azs, count.index)
  tags              = merge(local.tags, { Name = "public-yf-${count.index + 1}" })
}

resource "aws_subnet" "private_yf" {
  count             = 2
  vpc_id            = aws_vpc.vpc_yf.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + length(aws_subnet.public_yf))
  availability_zone = element(var.azs, count.index)
  tags              = merge(local.tags, { Name = "private-yf-${count.index + 1}" })
}

# INTERNET GATEWAY definition
resource "aws_internet_gateway" "igw_yf" {
  vpc_id = aws_vpc.vpc_yf.id
  tags   = merge(local.tags, { Name = "igw-yf" })
}

# ELASTIC IP definition
resource "aws_eip" "nat_eip" {
  tags = merge(local.tags, { Name = "eip-yf" })
}

# NAT GATEWAY definition
resource "aws_nat_gateway" "ngw_yf" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_yf[0].id
  tags          = merge(local.tags, { Name = "ngw-yf" })
  depends_on    = [aws_internet_gateway.igw_yf]
}

# ROUTE TABLES
resource "aws_route_table" "yf_rt_public" {
  vpc_id = aws_vpc.vpc_yf.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_yf.id
  }
  tags = merge(local.tags, { Name = "yf_rt_public" })
}

resource "aws_route_table" "yf_rt_private" {
  vpc_id = aws_vpc.vpc_yf.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw_yf.id
  }
  tags = merge(local.tags, { Name = "yf_rt_private" })
}

resource "aws_route_table_association" "yf_rt_public_association" {
  count          = 2
  subnet_id      = aws_subnet.public_yf[count.index].id
  route_table_id = aws_route_table.yf_rt_public.id
}

resource "aws_route_table_association" "yf_rt_private_association" {
  count          = 2
  subnet_id      = aws_subnet.private_yf[count.index].id
  route_table_id = aws_route_table.yf_rt_private.id
}


