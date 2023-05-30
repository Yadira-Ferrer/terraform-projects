# Define 'Locals' to Tag my resources
locals {
  tags = {
    Owner = "Yadira"
  }
  vars = {
    efs_dns = var.efs_dns
  }
}

resource "aws_launch_template" "yf_lt" {
  name          = "yf_launch_template"
  image_id      = var.ami
  instance_type = var.instance_type

  iam_instance_profile {
    arn = aws_iam_instance_profile.yf_profile.arn
  }

  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination       = true
    device_index                = 0
    security_groups             = [aws_security_group.ec2_sg.id]
  }

  key_name = "yf_tf_key"

  tags = merge(local.tags, { Name : "yf-launch-template" })

  user_data = base64encode(templatefile("${path.module}/init.sh", local.vars))
}

# INSTANCE PROFILE definition
resource "aws_iam_instance_profile" "yf_profile" {
  name = "yf-profile"
  role = aws_iam_role.role.name
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "role" {
  name               = "${var.project_name}-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# SECURITY GROUP definition
resource "aws_security_group" "ec2_sg" {
  name        = "${var.project_name}-ecs-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # To allow communication from EFS
  ingress {
    description = "EFS mount target"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # To allow communication from SSH
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.tags, { Name : "yf-ecs-sg" })
}

# Create a private key that will be used to login into servers
resource "tls_private_key" "web_key" {
  algorithm = "RSA"
}

# Save public key attributes from generated key
resource "aws_key_pair" "instance_key" {
  key_name   = "yf_tf_key"
  public_key = tls_private_key.web_key.public_key_openssh
}

# Save key to the local system
resource "local_file" "web_key_file" {
  content  = tls_private_key.web_key.private_key_pem
  filename = "web_key.pem"
}
