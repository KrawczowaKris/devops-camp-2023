data "aws_vpc" "target" {
  tags = var.vpc_tags
}

data "aws_subnets" "wordpress" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.target.id]
  }
}

data "aws_subnet" "subnet_az" {
  vpc_id = data.aws_vpc.target.id

  filter {
    name   = "availability-zone"
    values = [var.availability_zones[0]]
  }
}

data "aws_subnet" "subnet_bz" {
  vpc_id = data.aws_vpc.target.id

  filter {
    name   = "availability-zone"
    values = [var.availability_zones[1]]
  }
}

data "aws_subnet" "subnet_cz" {
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
