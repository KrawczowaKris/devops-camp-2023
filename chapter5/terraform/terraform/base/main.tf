module "wordpress_label" {
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=0.25.0"
  name        = var.client
  environment = var.environment
  attributes  = [var.project, var.cache_engine]
}

module "wordpress_instance_labels" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=0.25.0"
  for_each   = toset(var.cache_availability_zones)
  context    = module.wordpress_label.context
  attributes = [var.project, var.cache_engine, each.value]
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
    wordpress_tg     = join(module.wordpress_label.delimiter, [var.environment, var.client, "tg"])
    wordpress_alb    = join(module.wordpress_label.delimiter, [var.environment, var.client, "alb"])
    wordpress_alb_sg = join(module.wordpress_label.delimiter, [module.wordpress_label.id, "alb-sg"])
  }
  rds = {
    db_name     = module.wordpress_rds.db_instance_name
    random_pswd = random_password.rds_admin_password.result
    endpoint    = module.wordpress_rds.db_instance_endpoint
  }
  labels_wp_keys = {
    auth_key         = random_string.random["auth_key"].result
    secure_auth_key  = random_string.random["secure_auth_key"].result
    logged_in_key    = random_string.random["logged_in_key"].result
    nonce_key        = random_string.random["nonce_key"].result
    auth_salt        = random_string.random["auth_salt"].result
    secure_auth_salt = random_string.random["secure_auth_salt"].result
    logged_in_salt   = random_string.random["logged_in_salt"].result
    nonce_salt       = random_string.random["nonce_salt"].result
  }
  efs_id = module.wordpress_efs.id
}

/*
  ┌───────────────────────────────────────────────────────────────────────┐
  │ generate ssh-keys                                                     │
  └───────────────────────────────────────────────────────────────────────┘
*/

module "ssh_key_pair" {
  source                = "cloudposse/key-pair/aws"
  version               = "0.18.3"
  stage                 = var.environment
  name                  = var.client
  ssh_public_key_path   = "${path.cwd}/assets/private_keys"
  generate_ssh_key      = "true"
  private_key_extension = ".pem"
  public_key_extension  = ".pub"
}

/*
  ┌───────────────────────────────────────────────────────────────────────┐
  │ generate password for rds                                             │е7ЕН
  └───────────────────────────────────────────────────────────────────────┘
*/

resource "random_password" "rds_admin_password" {
  length  = 16
  special = false
}

/*
  ┌───────────────────────────────────────────────────────────────────────┐
  │ create security group for ec2                                         │
  └───────────────────────────────────────────────────────────────────────┘
*/

module "wordpress_ec2_sg" {
  source      = "terraform-aws-modules/security-group/aws"
  version     = "4.17.2"
  name        = local.labels.wordpress_ec2_sg
  description = "Security group for ec2"
  vpc_id      = data.aws_vpc.target.id
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "Open ssh connection"
      cidr_blocks = "195.201.120.196/32"
    }
  ]
  ingress_with_source_security_group_id = [
    {
      rule                     = "all-tcp"
      description              = "Open connection with rds security group"
      source_security_group_id = module.wordpress_rds_sg.security_group_id
    },
    {
      from_port                = 80
      to_port                  = 80
      protocol                 = "tcp"
      description              = "Open http connection"
      source_security_group_id = module.wordpress_alb_sg.security_group_id
    }
  ]
  egress_with_cidr_blocks = var.cache_egress_rules
  tags                    = var.tags
}

/*
  ┌───────────────────────────────────────────────────────────────────────┐
  │ create ec2                                                            │
  └───────────────────────────────────────────────────────────────────────┘
*/

module "wordpress_ec2" {
  for_each               = toset(var.cache_array_index_ec2)
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "5.0.0"
  name                   = "${local.labels.wordpress_ec2}-${each.value}"
  ami                    = var.cache_ami_id
  instance_type          = var.cache_instance_ec2_type
  key_name               = module.ssh_key_pair.key_name
  vpc_security_group_ids = [module.wordpress_ec2_sg.security_group_id]
  subnet_id              = data.aws_subnets.wordpress.ids[2]
  user_data = templatefile("${path.cwd}/terraform/base/userdata.tpl", {
    db_name          = local.rds.db_name,
    password_rds     = local.rds.random_pswd,
    endpoint         = local.rds.endpoint,
    auth_key         = local.labels_wp_keys.auth_key,
    secure_auth_key  = local.labels_wp_keys.secure_auth_key,
    logged_in_key    = local.labels_wp_keys.logged_in_key,
    nonce_key        = local.labels_wp_keys.nonce_key,
    auth_salt        = local.labels_wp_keys.auth_salt,
    secure_auth_salt = local.labels_wp_keys.secure_auth_salt,
    logged_in_salt   = local.labels_wp_keys.logged_in_salt,
    nonce_salt       = local.labels_wp_keys.nonce_salt
    efs_id           = local.efs_id
  })
  depends_on = [module.wordpress_rds]
  tags       = var.tags
}

/*
  ┌───────────────────────────────────────────────────────────────────────┐
  │ create security group for rds                                         │
  └───────────────────────────────────────────────────────────────────────┘
*/

module "wordpress_rds_sg" {
  source                   = "terraform-aws-modules/security-group/aws"
  version                  = "4.17.2"
  name                     = local.labels.wordpress_rds_sg
  description              = "Security group for rds"
  vpc_id                   = data.aws_vpc.target.id
  ingress_with_cidr_blocks = [var.cache_ingress_rules_rds[0]]
  ingress_with_source_security_group_id = [
    {
      rule                     = "mysql-tcp"
      description              = "Open connection with ec2 security group"
      source_security_group_id = module.wordpress_ec2_sg.security_group_id
    }
  ]
  egress_with_cidr_blocks = var.cache_egress_rules
  tags                    = var.tags
}

/*
  ┌───────────────────────────────────────────────────────────────────────┐
  │ create rds                                                            │
  └───────────────────────────────────────────────────────────────────────┘
*/

module "wordpress_rds" {
  source                              = "terraform-aws-modules/rds/aws"
  version                             = "5.9.0"
  identifier                          = "${var.environment}-${var.client}-rds"
  engine                              = "mysql"
  instance_class                      = var.cache_instance_rds_class
  family                              = "mysql${var.cache_rds_major_engine_version}"
  major_engine_version                = var.cache_rds_major_engine_version
  storage_type                        = var.cache_storage_type
  allocated_storage                   = var.cache_allocated_storage
  db_name                             = var.cache_rds_name
  username                            = "admin"
  port                                = "3306"
  iam_database_authentication_enabled = true
  vpc_security_group_ids              = [module.wordpress_rds_sg.security_group_id]
  maintenance_window                  = "Mon:00:00-Mon:03:00"
  backup_window                       = "03:00-06:00"
  create_db_subnet_group              = true
  subnet_ids                          = data.aws_subnets.wordpress.ids
  create_random_password              = false
  password                            = random_password.rds_admin_password.result
  tags                                = var.tags
}

/*
  ┌───────────────────────────────────────────────────────────────────────┐
  │ create efs                                                            │
  └───────────────────────────────────────────────────────────────────────┘
*/

module "wordpress_efs" {
  source          = "terraform-aws-modules/efs/aws"
  name            = local.labels.wordpress_efs
  throughput_mode = "elastic"
  mount_targets   = var.cache_mount_targets_efs

  security_group_name        = local.labels.wordpress_efs_sg
  security_group_description = "Security group for EFS"
  security_group_rules = {
    vpc = {
      description              = "Open nfs with ec2 instance"
      source_security_group_id = module.wordpress_ec2_sg.security_group_id
    }
  }

  lifecycle_policy = {
    transition_to_ia = "AFTER_30_DAYS"
  }

  attach_policy = false

  tags = var.tags
}

/*
  ┌───────────────────────────────────────────────────────────────────────┐
  │ create acm certificate for https listener on alb                      │
  └───────────────────────────────────────────────────────────────────────┘
*/

resource "aws_acm_certificate" "cert" {
  domain_name       = "${var.client}-exam.${var.cache_dns}"
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
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.record : record.fqdn]
}

/*
  ┌───────────────────────────────────────────────────────────────────────┐
  │ create security group for alb                                         │
  └───────────────────────────────────────────────────────────────────────┘
*/

module "wordpress_alb_sg" {
  source                   = "terraform-aws-modules/security-group/aws"
  version                  = "4.17.2"
  name                     = local.labels.wordpress_alb_sg
  description              = "Security group for application load balancer"
  vpc_id                   = data.aws_vpc.target.id
  ingress_with_cidr_blocks = var.cache_ingress_rules_alb
  egress_with_cidr_blocks  = var.cache_egress_rules
  tags                     = var.tags
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
      targets = {
        ec2_1 = {
          target_id = data.aws_instance.ec2-1.id
          port      = 80
        }
        ec2_2 = {
          target_id = data.aws_instance.ec2-2.id
          port      = 80
        }
      }
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

  depends_on = [data.aws_instance.ec2-1]

  tags = var.tags
}

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

/*
  ┌───────────────────────────────────────────────────────────────────────┐
  │ generate authentication unique keys and salts for wp-config.php       │
  └───────────────────────────────────────────────────────────────────────┘
*/

resource "random_string" "random" {
  for_each         = toset(var.cache_list_labels_random_values)
  length           = 64
  special          = true
  override_special = "<>{}()+*=#@;_/|"
}
