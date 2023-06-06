data "aws_vpc" "target" {
  tags = var.vpc_tags
}

data "aws_subnets" "wordpress" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.target.id]
  }
}

data "aws_subnet" "subnet_a" {
  vpc_id = data.aws_vpc.target.id

  filter {
    name   = "availability-zone"
    values = [var.availability_zones[0]]
  }
}

data "aws_subnet" "subnet_b" {
  vpc_id = data.aws_vpc.target.id

  filter {
    name   = "availability-zone"
    values = [var.availability_zones[1]]
  }
}

data "aws_subnet" "subnet_c" {
  vpc_id = data.aws_vpc.target.id

  filter {
    name   = "availability-zone"
    values = [var.availability_zones[2]]
  }
}

data "aws_route53_zone" "zone_record" {
  name         = var.hosted_zone
  private_zone = false
}

data "aws_instances" "ec2" {
  filter {
    name   = "tag:Name"
    values = module.wordpress_ec2[*].tags_all.Name
  }

  filter {
    name   = "instance-state-name"
    values = ["running"]
  }

  depends_on = [module.wordpress_ec2]
}
