/*
  ┌───────────────────────────────────────────────────────────────────────┐
  │ create rds                                                            │
  └───────────────────────────────────────────────────────────────────────┘
*/

module "wordpress_rds" {
  source                              = "terraform-aws-modules/rds/aws"
  version                             = "5.9.0"
  identifier                          = local.labels.wordpress_rds
  engine                              = var.rds_engine
  instance_class                      = var.instance_rds_class
  family                              = "${var.rds_engine}${var.rds_major_engine_version}"
  major_engine_version                = var.rds_major_engine_version
  storage_type                        = var.rds_storage_type
  allocated_storage                   = var.rds_allocated_storage
  db_name                             = var.rds_name
  username                            = "admin"
  port                                = "3306"
  iam_database_authentication_enabled = true
  vpc_security_group_ids              = [module.wordpress_rds_sg.security_group_id]
  maintenance_window                  = var.rds_maintenance_window
  backup_window                       = var.rds_backup_window
  create_db_subnet_group              = true
  subnet_ids                          = data.aws_subnets.wordpress.ids
  create_random_password              = false
  password                            = random_password.rds_admin_password.result
  tags                                = var.tags
}
