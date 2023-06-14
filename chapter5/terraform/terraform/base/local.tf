module "wordpress_label" {
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=0.25.0"
  name        = var.owner
  environment = var.environment
  attributes  = [var.project]
}

locals {
  labels = {
    wordpress_sg     = join(module.wordpress_label.delimiter, [module.wordpress_label.id, "sg"])
    wordpress_ec2_sg = join(module.wordpress_label.delimiter, [module.wordpress_label.id, "ec2-sg"])
    wordpress_ec2    = join(module.wordpress_label.delimiter, [module.wordpress_label.id, "ec2"])
    wordpress_rds_sg = join(module.wordpress_label.delimiter, [module.wordpress_label.id, "rds-sg"])
    wordpress_rds    = join(module.wordpress_label.delimiter, [module.wordpress_label.id, "rds"])
    wordpress_efs_sg = join(module.wordpress_label.delimiter, [module.wordpress_label.id, "efs-sg"])
    wordpress_efs    = join(module.wordpress_label.delimiter, [module.wordpress_label.id, "efs"])
    wordpress_tg     = join(module.wordpress_label.delimiter, [var.environment, var.owner, "tg"])
    wordpress_alb    = join(module.wordpress_label.delimiter, [var.environment, var.owner, "alb"])
    wordpress_alb_sg = join(module.wordpress_label.delimiter, [module.wordpress_label.id, "alb-sg"])
  }
  domain_name = join(module.wordpress_label.delimiter, [var.owner, "exam.${var.hosted_zone}"])
}
