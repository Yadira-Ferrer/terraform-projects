# EFS Output

output "efs_dns" {
  value = aws_efs_file_system.yf_efs.dns_name
}
