output "lc_id" {
  value = aws_launch_template.yf_lt.id
}

output "ec2_sg" {
  value = aws_security_group.ec2_sg.id
}

output "private_key" {
  value = tls_private_key.web_key.private_key_pem
}
