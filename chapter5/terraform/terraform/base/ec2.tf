/*
  ┌───────────────────────────────────────────────────────────────────────┐
  │ create ec2                                                            │
  └───────────────────────────────────────────────────────────────────────┘
*/

module "wordpress_ec2" {
  count                  = var.wordpress_ec2_instances_count
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "5.0.0"
  name                   = "${local.labels.wordpress_ec2}-${count.index}"
  ami                    = var.wordpress_ec2_instance_ami_id
  instance_type          = var.wordpress_ec2_instance_type
  key_name               = module.ssh_key_pair.key_name
  vpc_security_group_ids = [module.wordpress_ec2_sg.security_group_id]
  subnet_id              = data.aws_subnet.subnet_a.id
  user_data = templatefile("${path.cwd}/terraform/base/userdata.tpl", {
    db_name      = var.wordpress_rds_name
    password_rds = random_password.rds_admin_password.result
    endpoint     = module.wordpress_rds.db_instance_endpoint
    // authentication unique keys and salts for wp-config.php
    auth_key         = random_string.random["auth_key"].result
    secure_auth_key  = random_string.random["secure_auth_key"].result
    logged_in_key    = random_string.random["logged_in_key"].result
    nonce_key        = random_string.random["nonce_key"].result
    auth_salt        = random_string.random["auth_salt"].result
    secure_auth_salt = random_string.random["secure_auth_salt"].result
    logged_in_salt   = random_string.random["logged_in_salt"].result
    nonce_salt       = random_string.random["nonce_salt"].result
    efs_id           = module.wordpress_efs.id
    fqdn_record      = aws_acm_certificate.cert.domain_name
  })
  depends_on = [module.wordpress_rds]
  tags       = var.tags
}
