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

ip_address = "195.201.120.196/32"

wordpress_instances_count = 2

dns_name = "saritasa-camps.link"

vpc_tags = {
  Name = "default"
}

availability_zones = ["us-east-2a", "us-east-2b", "us-east-2c"]

instance_ec2_type = "t3.micro"
instance_ami_id   = "ami-08333bccc35d71140"

rds_name                 = "nadezhda_niukina_user_db"
instance_rds_class       = "db.t4g.micro"
rds_major_engine_version = "8.0"
rds_storage_type         = "gp3"
rds_allocated_storage    = "20"
rds_maintenance_window = "Mon:00:00-Mon:03:00"
rds_backup_window = "03:00-06:00"
rds_engine = "mysql"

list_labels_random_values = ["auth_key", "secure_auth_key", "logged_in_key", "nonce_key", "auth_salt", "secure_auth_salt", "logged_in_salt", "nonce_salt"]

efs_throughput_mode = "elastic"
efs_transition_to_ia = "AFTER_30_DAYS"
