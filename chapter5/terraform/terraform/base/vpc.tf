data "aws_vpc" "target" {
  tags = var.vpc_tags_filter
}

data "aws_subnets" "wordpress" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.target.id]
  }
}

data "aws_subnet" "subnets" {
  for_each = toset(data.aws_subnets.wordpress.ids)
  id       = each.value
}
