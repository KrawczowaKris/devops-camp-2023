/*
  ┌───────────────────────────────────────────────────────────────────────┐
  │ create acm certificate for https listener on alb                      │
  └───────────────────────────────────────────────────────────────────────┘
*/

resource "aws_acm_certificate" "cert" {
  domain_name       = "${var.owner}-exam.${var.hosted_zone}"
  validation_method = "DNS"
}

resource "aws_route53_record" "record" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.zone_record.zone_id
}

resource "aws_acm_certificate_validation" "cert_valid" {
  certificate_arn = aws_acm_certificate.cert.arn
  validation_record_fqdns = [aws_route53_record.record[aws_acm_certificate.cert.domain_name].fqdn]
  #validation_record_fqdns = [for record in aws_route53_record.record : record.fqdn]
}
