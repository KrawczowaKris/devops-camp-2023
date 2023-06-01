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

cache_dns = "saritasa-camps.link"

cache_vpc_tags = {
  Name = "default"
}

cache_availability_zones = ["us-east-2a", "us-east-2b"]
cache_engine             = "wordpress"

cache_array_index_ec2   = ["1", "2"]
cache_instance_ec2_type = "t3.micro"
cache_ami_id            = "ami-08333bccc35d71140"

cache_instance_rds_class       = "db.t4g.micro"
cache_rds_major_engine_version = "8.0"
cache_storage_type             = "gp3"
cache_allocated_storage        = "20"
cache_rds_name                 = "nadezhda_niukina_user_db"

cache_ingress_rules_rds = [
  {
    rule        = "mysql-tcp"
    description = "Open connection with mysql"
    cidr_blocks = "195.201.120.196/32"
  },
]

cache_ingress_rules_alb = [
  {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = "0.0.0.0/0"
    description = "Open https connection"
  },
  {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = "0.0.0.0/0"
    description = "Open http connection"
  }
]

cache_egress_rules = [
  {
    rule        = "all-all"
    description = "Open all ipv4 connection"
    cidr_blocks = "0.0.0.0/0"
  }
]

cache_mount_targets_efs = {
  "us-east-2a" = {
    subnet_id = "subnet-06bf7d626cfb50b30"
  }
  "us-east-2b" = {
    subnet_id = "subnet-0412d6a553a654a0a"
  }
  "us-east-2c" = {
    subnet_id = "subnet-0c437405f83328b86"
  }
}

cache_list_labels_random_values = ["auth_key", "secure_auth_key", "logged_in_key", "nonce_key", "auth_salt", "secure_auth_salt", "logged_in_salt", "nonce_salt"]
