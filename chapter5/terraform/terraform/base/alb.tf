/*
  ┌───────────────────────────────────────────────────────────────────────┐
  │ create target group for alb                                           │
  └───────────────────────────────────────────────────────────────────────┘
*/

resource "aws_lb_target_group" "wordpress_tg_type" {
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = data.aws_vpc.target.id
}

resource "aws_lb_target_group_attachment" "wordpress_tg" {
  count = var.wordpress_ec2_instances_count

  port             = 80
  target_id        = module.wordpress_ec2[count.index].id
  target_group_arn = aws_lb_target_group.wordpress_tg_type.arn
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
      backend_port     = 80
      backend_protocol = "HTTP"
      name             = local.labels.wordpress_tg
      targets          = aws_lb_target_group_attachment.wordpress_tg
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

  depends_on = [module.wordpress_ec2]
}
