output "vpc_id" {
  value = aws_vpc.vpc_yf.id
  description = "Returns VPC ID"
}

output "public_subnets" {
  value = aws_subnet.public_yf[*].id
}

output "private_subnets" {
  value = aws_subnet.private_yf[*].id
}

output "az" {
  value = data.aws_availability_zones.available
}