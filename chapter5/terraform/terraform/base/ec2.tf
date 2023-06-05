/*
  ┌───────────────────────────────────────────────────────────────────────┐
  │ create ec2                                                            │
  └───────────────────────────────────────────────────────────────────────┘
*/

module "wordpress_ec2" {
  count                  = var.wordpress_instances_count
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "5.0.0"
  name                   = "${local.labels.wordpress_ec2}-${count.index}"
  ami                    = var.instance_ami_id
  instance_type          = var.instance_ec2_type
  key_name               = module.ssh_key_pair.key_name
  vpc_security_group_ids = [module.wordpress_ec2_sg.security_group_id]
  subnet_id              = data.aws_subnets.wordpress.ids[2]
  user_data = templatefile("${path.cwd}/terraform/base/userdata.tpl", {
    db_name          = local.rds.db_name,
    password_rds     = local.rds.random_pwd,
    endpoint         = local.rds.endpoint,
    auth_key         = local.wp_keys.auth_key,
    secure_auth_key  = local.wp_keys.secure_auth_key,
    logged_in_key    = local.wp_keys.logged_in_key,
    nonce_key        = local.wp_keys.nonce_key,
    auth_salt        = local.wp_keys.auth_salt,
    secure_auth_salt = local.wp_keys.secure_auth_salt,
    logged_in_salt   = local.wp_keys.logged_in_salt,
    nonce_salt       = local.wp_keys.nonce_salt
    efs_id           = local.efs_id
    fqdn_record      = local.fqdn_record
  })
  depends_on = [module.wordpress_rds]
  tags       = var.tags
}
