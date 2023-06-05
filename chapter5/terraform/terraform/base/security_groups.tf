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
      rule        = "ssh-tcp"
      description = "Open ssh connection"
      cidr_blocks = var.ip_address
    }
  ]
  ingress_with_source_security_group_id = [
    {
      rule                     = "all-tcp"
      description              = "Open connection with rds security group"
      source_security_group_id = module.wordpress_rds_sg.security_group_id
    },
    {
      rule                     = "http-80-tcp"
      description              = "Open http connection"
      source_security_group_id = module.wordpress_alb_sg.security_group_id
    }
  ]
  egress_with_cidr_blocks = [
    {
      rule        = "all-all"
      description = "Open all ipv4 connection"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  tags = var.tags
}

/*
  ┌───────────────────────────────────────────────────────────────────────┐
  │ create security group for rds                                         │
  └───────────────────────────────────────────────────────────────────────┘
*/

module "wordpress_rds_sg" {
  source      = "terraform-aws-modules/security-group/aws"
  version     = "4.17.2"
  name        = local.labels.wordpress_rds_sg
  description = "Security group for rds"
  vpc_id      = data.aws_vpc.target.id
  ingress_with_cidr_blocks = [
    {
      rule        = "mysql-tcp"
      description = "Open connection with mysql"
      cidr_blocks = "195.201.120.196/32"
    },
  ]
  ingress_with_source_security_group_id = [
    {
      rule                     = "mysql-tcp"
      description              = "Open connection with ec2 security group"
      source_security_group_id = module.wordpress_ec2_sg.security_group_id
    }
  ]
  egress_with_cidr_blocks = [
    {
      rule        = "all-all"
      description = "Open all ipv4 connection"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  tags = var.tags
}

/*
  ┌───────────────────────────────────────────────────────────────────────┐
  │ create security group for alb                                         │
  └───────────────────────────────────────────────────────────────────────┘
*/

module "wordpress_alb_sg" {
  source      = "terraform-aws-modules/security-group/aws"
  version     = "4.17.2"
  name        = local.labels.wordpress_alb_sg
  description = "Security group for application load balancer"
  vpc_id      = data.aws_vpc.target.id
  ingress_with_cidr_blocks = [
    {
      rule        = "https-443-tcp"
      cidr_blocks = "0.0.0.0/0"
      description = "Open https connection"
    },
    {
      rule        = "http-80-tcp"
      cidr_blocks = "0.0.0.0/0"
      description = "Open http connection"
    }
  ]
  egress_with_cidr_blocks = [
    {
      rule        = "all-all"
      description = "Open all ipv4 connection"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  tags = var.tags
}
