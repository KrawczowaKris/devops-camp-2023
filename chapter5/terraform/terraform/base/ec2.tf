/*
  ┌───────────────────────────────────────────────────────────────────────┐
  │ generate authentication unique keys and salts for wp-config.php       │
  └───────────────────────────────────────────────────────────────────────┘
*/

resource "random_string" "wordpress_keys" {
  for_each         = toset(var.wordpress_secret_keys)
  length           = 64
  special          = true
  override_special = "<>{}()+*=#@;_/|"
}

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
  subnet_id              = element(data.aws_subnets.wordpress.ids, count.index)
  user_data = templatefile("${path.cwd}/terraform/base/userdata.tpl", {
    rds_name         = module.wordpress_rds.db_instance_name
    rds_user         = module.wordpress_rds.db_instance_username
    rds_password     = module.wordpress_rds.db_instance_password
    rds_endpoint     = module.wordpress_rds.db_instance_endpoint
    auth_key         = random_string.wordpress_keys["auth_key"].result # authentication unique keys and salts for wp-config.php
    auth_salt        = random_string.wordpress_keys["auth_salt"].result
    logged_in_key    = random_string.wordpress_keys["logged_in_key"].result
    logged_in_salt   = random_string.wordpress_keys["logged_in_salt"].result
    nonce_key        = random_string.wordpress_keys["nonce_key"].result
    nonce_salt       = random_string.wordpress_keys["nonce_salt"].result
    secure_auth_key  = random_string.wordpress_keys["secure_auth_key"].result
    secure_auth_salt = random_string.wordpress_keys["secure_auth_salt"].result
    efs_id           = module.wordpress_efs.id
    fqdn_record      = aws_acm_certificate.cert.domain_name
  })
  depends_on = [module.wordpress_rds, module.wordpress_efs]
}
