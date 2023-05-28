output "alb_sg" {
  value = aws_security_group.alb_sg.id
}

output "alb_id" {
  value = aws_lb.yf_alb.id
}

output "alb_dns" {
  value = aws_lb.yf_alb.dns_name
}

output "alb_zone_id" {
  value = aws_lb.yf_alb.zone_id
}

output "target_group_arns" {
  description = "ARNs of the target groups. Useful for passing to your Auto Scaling group"
  value       = aws_lb_target_group.alb_tg.arn
}
