/*
  ┌───────────────────────────────────────────────────────────────────────┐
  │ create route53 record for alb                                         │
  └───────────────────────────────────────────────────────────────────────┘
*/

resource "aws_route53_record" "a_record_for_alb" {
  zone_id = data.aws_route53_zone.zone_record.zone_id
  name    = aws_acm_certificate.cert.domain_name
  type    = "A"

  alias {
    name                   = module.wordpress_alb.lb_dns_name
    zone_id                = module.wordpress_alb.lb_zone_id
    evaluate_target_health = true
  }

  depends_on = [module.wordpress_alb]
}
