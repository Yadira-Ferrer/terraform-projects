# Define 'Locals' to Tag my resources
locals {
  tags = {
    Owner = "Yadira"
  }
}

# APPLICATION LOAD BALANCER definition
resource "aws_lb" "yf_alb" {
  name                             = "yf-alb"
  internal                         = false
  load_balancer_type               = "application"
  security_groups                  = [aws_security_group.alb_sg.id]
  subnets                          = var.subnets
  enable_cross_zone_load_balancing = "true"

  tags = local.tags
}

# ALB LISTENER definition
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.yf_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}

# TARGET GROUP definition
resource "aws_lb_target_group" "alb_tg" {
  name     = "yf-alb-tg"
  port     = 80
  protocol = "HTTP"
  /* target_type = "ip" */
  vpc_id = var.vpc_id

  tags = merge(local.tags, { Name : "yf-tg" })
}

# SECURITY GROUP for ALB
resource "aws_security_group" "alb_sg" {
  name        = "${var.project_name}-alb-sg"
  description = "Security group for ALB"
  vpc_id      = var.vpc_id

  # Inbound Rules
  # HTTP access from anywhere
  ingress {
    description = "Allow all traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS access from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound Rules
  # Internet access to anywhere
  egress {
    description = "Allow all traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.tags, { Name : "yf-alb-sg" })
}

