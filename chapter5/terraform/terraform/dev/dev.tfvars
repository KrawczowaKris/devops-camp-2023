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

eks_office_public_ip_address = "195.201.120.196/32"

hosted_zone = "saritasa-camps.link"

availability_zones = ["us-east-2a", "us-east-2b", "us-east-2c"]

vpc_tags = {
  Name = "default"
}

wordpress_ec2_instances_count = 2
wordpress_ec2_instance_type   = "t3.micro"
# Amazon Linux 2023 AMI 2023.0.20230503.0 x86_64 HVM kernel-6.1
# https://us-east-2.console.aws.amazon.com/ec2/home?region=us-east-2#ImageDetails:imageId=ami-08333bccc35d71140
wordpress_ec2_instance_ami_id = "ami-08333bccc35d71140"

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

wordpress_labels_random_values = [
  "auth_key",
  "auth_salt",
  "logged_in_key",
  "logged_in_salt",
  "nonce_key",
  "nonce_salt",
  "secure_auth_key",
  "secure_auth_salt"
]
