/*
  ┌───────────────────────────────────────────────────────────────────────┐
  │ generate password for rds                                             │
  └───────────────────────────────────────────────────────────────────────┘
*/

resource "random_password" "rds_admin_password" {
  length  = 16
  special = false
}

/*
  ┌───────────────────────────────────────────────────────────────────────┐
  │ create rds                                                            │
  └───────────────────────────────────────────────────────────────────────┘
*/

module "wordpress_rds" {
  source                              = "terraform-aws-modules/rds/aws"
  version                             = "5.9.0"
  identifier                          = local.labels.wordpress_rds
  engine                              = var.wordpress_rds_engine
  instance_class                      = var.wordpress_rds_instance_type
  family                              = var.wordpress_rds_family
  major_engine_version                = var.wordpress_rds_major_engine_version
  storage_type                        = var.wordpress_rds_storage_type
  allocated_storage                   = var.wordpress_rds_allocated_storage
  db_name                             = var.wordpress_rds_name
  username                            = var.wordpress_rds_username
  port                                = var.wordpress_rds_port
  iam_database_authentication_enabled = true
  vpc_security_group_ids              = [module.wordpress_rds_sg.security_group_id]
  maintenance_window                  = var.wordpress_rds_maintenance_window
  backup_window                       = var.wordpress_rds_backup_window
  create_db_subnet_group              = true
  subnet_ids                          = data.aws_subnets.wordpress.ids
  create_random_password              = false
  password                            = random_password.rds_admin_password.result
  skip_final_snapshot                 = true
}
