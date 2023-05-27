resource "aws_autoscaling_group" "yf-asg" {
  name                      = "${var.project_name}-asg"
  desired_capacity          = 2
  max_size                  = 4
  min_size                  = 2
  default_cooldown          = "60"
  health_check_grace_period = "600"

  launch_template {
    id      = var.lc_id
    version = "$Latest"
  }

  vpc_zone_identifier = var.subnets

  # Add load balancer...
}
