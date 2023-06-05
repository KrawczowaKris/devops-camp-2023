/*
  ┌───────────────────────────────────────────────────────────────────────┐
  │ create target group for alb                                           │
  └───────────────────────────────────────────────────────────────────────┘
*/

resource "aws_lb_target_group" "wordpress_tg_type" {
  port             = 80
  protocol         = "HTTP"
  target_type      = "instance"
  vpc_id           = data.aws_vpc.target.id
}

resource "aws_lb_target_group_attachment" "wordpress_tg" {
  count = var.wordpress_instances_count

  target_group_arn = aws_lb_target_group.wordpress_tg_type.arn
  target_id        = module.wordpress_ec2[count.index].id
  port             = 80
}

/*
  ┌───────────────────────────────────────────────────────────────────────┐
  │ create alb                                                            │
  └───────────────────────────────────────────────────────────────────────┘
*/

module "wordpress_alb" {
  source             = "terraform-aws-modules/alb/aws"
  version            = "8.6.0"
  name               = local.labels.wordpress_alb
  load_balancer_type = "application"
  vpc_id             = data.aws_vpc.target.id
  subnets            = data.aws_subnets.wordpress.ids
  security_groups    = [module.wordpress_alb_sg.security_group_id]

  target_groups = [
    {
      name             = local.labels.wordpress_tg
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      targets = aws_lb_target_group_attachment.wordpress_tg
    }
  ]

  https_listeners = [
    {
      port            = 443
      protocol        = "HTTPS"
      certificate_arn = aws_acm_certificate_validation.cert_valid.certificate_arn
    }
  ]

  http_tcp_listeners = [
    {
      port        = 80
      protocol    = "HTTP"
      action_type = "redirect"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  ]

  depends_on = [data.aws_instances.ec2]

  tags = var.tags
}
