data "aws_vpc" "target" {
  tags = var.vpc_tags
}

data "aws_subnets" "wordpress" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.target.id]
  }
}

data "aws_subnet" "filtered_subnets" {
  for_each = toset(var.availability_zones)
  vpc_id   = data.aws_vpc.target.id

  filter {
    name   = "availability-zone"
    values = [each.value]
  }
}

data "aws_route53_zone" "zone_record" {
  name         = var.dns_name
  private_zone = false
}

data "aws_instances" "ec2" {
  filter {
    name   = "tag:Name"
    values = [for instance in module.wordpress_ec2 : instance.tags_all.Name]
  }

  filter {
    name   = "instance-state-name"
    values = ["running"]
  }

  depends_on = [module.wordpress_ec2]
}
