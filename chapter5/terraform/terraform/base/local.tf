locals {
  labels = {
    wordpress_sg     = join(module.wordpress_label.delimiter, [module.wordpress_label.id, "sg"])
    wordpress_ec2_sg = join(module.wordpress_label.delimiter, [module.wordpress_label.id, "ec2-sg"])
    wordpress_ec2    = join(module.wordpress_label.delimiter, [module.wordpress_label.id, "ec2"])
    wordpress_rds_sg = join(module.wordpress_label.delimiter, [module.wordpress_label.id, "rds-sg"])
    wordpress_rds    = join(module.wordpress_label.delimiter, [module.wordpress_label.id, "rds"])
    wordpress_efs_sg = join(module.wordpress_label.delimiter, [module.wordpress_label.id, "efs-sg"])
    wordpress_efs    = join(module.wordpress_label.delimiter, [module.wordpress_label.id, "efs"])
    wordpress_tg     = join(module.wordpress_label.delimiter, [var.environment, var.owner, "tg"])
    wordpress_alb    = join(module.wordpress_label.delimiter, [var.environment, var.owner, "alb"])
    wordpress_alb_sg = join(module.wordpress_label.delimiter, [module.wordpress_label.id, "alb-sg"])
  }
  rds = {
    db_name    = module.wordpress_rds.db_instance_name
    random_pwd = random_password.rds_admin_password.result
    endpoint   = module.wordpress_rds.db_instance_endpoint
  }
  // authentication unique keys and salts for wp-config.php
  wp_keys = {
    auth_key         = random_string.random["auth_key"].result
    secure_auth_key  = random_string.random["secure_auth_key"].result
    logged_in_key    = random_string.random["logged_in_key"].result
    nonce_key        = random_string.random["nonce_key"].result
    auth_salt        = random_string.random["auth_salt"].result
    secure_auth_salt = random_string.random["secure_auth_salt"].result
    logged_in_salt   = random_string.random["logged_in_salt"].result
    nonce_salt       = random_string.random["nonce_salt"].result
  }
  efs_id      = module.wordpress_efs.id
  fqdn_record = aws_acm_certificate.cert.domain_name
}
