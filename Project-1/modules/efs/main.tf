# EFS Module

# Define 'Locals' to Tag my resources
locals {
  tags = {
    Owner = "Yadira"
  }
}

# Create EFS resource
resource "aws_efs_file_system" "yf_efs" {
  creation_token = "yf-efs"
  tags           = merge(local.tags, { Name : "yf-efs" })
}

# Create mount targets of EFS
resource "aws_efs_mount_target" "yf_mount_1" {
  depends_on      = [aws_efs_file_system.yf_efs]
  file_system_id  = aws_efs_file_system.yf_efs.id
  subnet_id       = var.subnets[0]
  security_groups = [var.ec2_sg]
}

resource "aws_efs_mount_target" "yf_mount_2" {
  depends_on      = [aws_efs_file_system.yf_efs]
  file_system_id  = aws_efs_file_system.yf_efs.id
  subnet_id       = var.subnets[1]
  security_groups = [var.ec2_sg]
}

# Access Point
resource "aws_efs_access_point" "efs_access_point" {
  file_system_id = aws_efs_file_system.yf_efs.id
  root_directory {
    creation_info {
      owner_gid   = 1000
      owner_uid   = 1000
      permissions = 755
    }
    path = "/usr/share/nginx/html"
  }
}
