/*
  ┌───────────────────────────────────────────────────────────────────────┐
  │ create acm certificate for https listener on alb                      │
  └───────────────────────────────────────────────────────────────────────┘
*/

resource "aws_acm_certificate" "cert" {
  domain_name       = local.domain_name
  validation_method = "DNS"
}

resource "aws_acm_certificate_validation" "cert_valid" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = values(aws_route53_record.acm_cname_record)[*].fqdn
}
