data "aws_route53_zone" "zone_record" {
  name         = var.hosted_zone
  private_zone = false
}

/*
  ┌───────────────────────────────────────────────────────────────────────┐
  │ create route53 record for certificate                                 │
  └───────────────────────────────────────────────────────────────────────┘
*/

resource "aws_route53_record" "acm_cname_record" {
  for_each = {
    for validated_domain_name in aws_acm_certificate.cert.domain_validation_options : validated_domain_name.domain_name => {
      name   = validated_domain_name.resource_record_name
      record = validated_domain_name.resource_record_value
      type   = validated_domain_name.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.zone_record.zone_id
}

/*
  ┌───────────────────────────────────────────────────────────────────────┐
  │ create route53 record for alb                                         │
  └───────────────────────────────────────────────────────────────────────┘
*/

resource "aws_route53_record" "a_record_for_alb" {
  zone_id = data.aws_route53_zone.zone_record.zone_id
  name    = local.domain_name
  type    = "A"

  alias {
    name                   = module.wordpress_alb.lb_dns_name
    zone_id                = module.wordpress_alb.lb_zone_id
    evaluate_target_health = true
  }

  depends_on = [module.wordpress_alb]
}
