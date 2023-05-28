# Route53 Outputs

output "acm_cert_validation" {
  value = aws_acm_certificate_validation.yf_validation.certificate_arn
}
