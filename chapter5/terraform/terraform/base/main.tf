module "wordpress_label" {
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=0.25.0"
  name        = var.owner
  environment = var.environment
  attributes  = [var.project]
}

module "wordpress_instance_labels" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=0.25.0"
  for_each   = toset(var.availability_zones)
  context    = module.wordpress_label.context
  attributes = [var.project, each.value]
}
