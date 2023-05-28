# Locals
locals {
  tags = {
    Owner = "Yadira"
  }
}

# Definition of SSL certificate 
resource "aws_acm_certificate" "yf_acm" {
  domain_name       = "yferrer.training.test-something.com"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = local.tags
}

# Definition of Route53 record
resource "aws_route53_record" "yf_cert_validation_record" {
  for_each = {
    for dvo in aws_acm_certificate.yf_acm.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  type            = each.value.type
  zone_id         = var.zone_id
  ttl             = 60

}

# This tells terraform to cause the route53 validation to happen
resource "aws_acm_certificate_validation" "yf_validation" {
  timeouts {
    create = "5m"
  }
  certificate_arn         = aws_acm_certificate.yf_acm.arn
  validation_record_fqdns = [for record in aws_route53_record.yf_cert_validation_record : record.fqdn]
}

# Standard route53 DNS record for "myapp" pointing to an ALB
resource "aws_route53_record" "yf_cname_record" {
  zone_id = var.zone_id
  name    = "yferrer.training.test-something.com"
  type    = "A"

  alias {
    name                   = var.alb_dns
    zone_id                = var.alb_zone_id
    evaluate_target_health = false
  }
}
