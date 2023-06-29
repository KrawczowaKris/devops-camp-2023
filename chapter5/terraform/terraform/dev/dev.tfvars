/* 
  ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ env=specific configuration variables                                                                             │
  └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/

environment = "dev"

/* 
  ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ wordpress configuration variables                                                                                    │
  └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/

allowed_ec2_ssh_ips = [
  "195.201.120.196/32"
]

hosted_zone                = "saritasa-camps.link"
wordpress_subdomain_prefix = "exam"

vpc_tags_filter = {
  Name = "default"
}

wordpress_ec2_instances_count = 2
wordpress_ec2_instance_type   = "t3.micro"
wordpress_ec2_instance_ami_id = "ami-08333bccc35d71140" # Amazon Linux 2023 AMI 2023.0.20230503.0 x86_64 HVM kernel-6.1
# https://us-east-2.console.aws.amazon.com/ec2/home?region=us-east-2#ImageDetails:imageId=ami-08333bccc35d71140

wordpress_rds_name                 = "nadezhda_niukina_user_db"
wordpress_rds_instance_type        = "db.t4g.micro"
wordpress_rds_major_engine_version = "8.0"
wordpress_rds_storage_type         = "gp3"
wordpress_rds_allocated_storage    = "20"
wordpress_rds_backup_window        = "03:00-06:00"
wordpress_rds_maintenance_window   = "Mon:00:00-Mon:03:00"
wordpress_rds_engine               = "mysql"
wordpress_rds_family               = "mysql8.0"

wordpress_efs_throughput_mode  = "elastic"
wordpress_efs_transition_to_ia = "AFTER_30_DAYS"

wordpress_secret_keys = [
  "auth_key",        # for making changes to the site
  "auth_salt",       # for encrypting user passwords when they authenticate on the site
  "logged_in_key",   # for creating a cookie for a logged in user
  "logged_in_salt",  # for creating secure cookies that are used to authenticate users who are already logged into the site
  "nonce_key",       # for signing the nonce key
  "nonce_salt",      # for to generating nonce security tokens
  "secure_auth_key", # for signing the authorization cookie for the SSL administrator
  "secure_auth_salt" # for creating secure cookies that are used to authenticate users on the site
]
