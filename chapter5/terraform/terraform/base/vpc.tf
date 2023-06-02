data "aws_vpc" "target" {
  tags = var.cache_vpc_tags
}

data "aws_subnets" "wordpress" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.target.id]
  }
}

data "aws_route53_zone" "zone_record" {
  name         = var.cache_dns
  private_zone = false
}

data "aws_instance" "ec2-1" {
  filter {
    name   = "tag:Name"
    values = ["${var.environment}-${var.client}-${var.project}-ec2-${var.cache_array_index_ec2[0]}"]
  }

  filter {
    name   = "instance-state-name"
    values = ["running"]
  }

  depends_on = [module.wordpress_ec2]
}

data "aws_instance" "ec2-2" {
  filter {
    name   = "tag:Name"
    values = ["${var.environment}-${var.client}-${var.project}-ec2-${var.cache_array_index_ec2[1]}"]
  }

  filter {
    name   = "instance-state-name"
    values = ["running"]
  }

  depends_on = [module.wordpress_ec2]
}
