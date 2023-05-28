output "lc_id" {
  value = aws_launch_template.yf_lt.id
}

output "ecs_sg" {
  value = aws_security_group.ecs_sg.id
}
