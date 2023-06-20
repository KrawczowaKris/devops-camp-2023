variable "allowed_ec2_ssh_ips" {
  description = "List of corporate IP addresses for ssh access to ec2 instances and rds"
  type        = list(string)
}

variable "hosted_zone" {
  description = "Hosted zone for dns records for site"
  type        = string
}

variable "domain_postfix" {
  description = "Postfix for domain name for site"
  type        = string
  default     = ""
}

variable "vpc_tags" {
  description = "VPC tags to place host or ec2 instances into"
  type        = map(string)
  default = {
    Name = "default"
  }
}

/* 
  ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ variables for ec2 instances                                                                                      │
  └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/

variable "wordpress_ec2_instances_count" {
  description = "Number of wordpress instances under load-balancing"
  type        = number
}

variable "wordpress_ec2_instance_type" {
  description = "Type of instance ec2"
  type        = string
}

variable "wordpress_ec2_instance_ami_id" {
  description = "ID of AMI type for ec2 instance"
  type        = string
}

/* 
  ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ variables for rds                                                                                                │
  └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/

variable "wordpress_rds_name" {
  description = "Name of RDS"
  type        = string
}

variable "wordpress_rds_instance_type" {
  description = "Type of instance rds class"
  type        = string
}

variable "wordpress_rds_major_engine_version" {
  description = "Database major engine version"
  type        = string
}

variable "wordpress_rds_storage_type" {
  description = "Type of storage for RDS"
  type        = string
}

variable "wordpress_rds_allocated_storage" {
  description = "Amount of allocated storage for RDS"
  type        = string
}

variable "wordpress_rds_backup_window" {
  description = "Backup window for RDS"
  type        = string
}

variable "wordpress_rds_maintenance_window" {
  description = "Maintenance window for RDS"
  type        = string
}

variable "wordpress_rds_engine" {
  description = "Engine for RDS"
  type        = string
}

variable "wordpress_rds_family" {
  description = "Family of RDS"
  type        = string
}

variable "wordpress_rds_username" {
  description = "Username of RDS user"
  type        = string
  default     = "admin"
}

variable "wordpress_rds_port" {
  description = "Port for RDS"
  type        = number
  default     = 3306
}

/* 
  ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ variables for efs                                                                                                │
  └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/

variable "wordpress_efs_throughput_mode" {
  description = "Throughput mode for EFS"
  type        = string
}

variable "wordpress_efs_transition_to_ia" {
  description = "Transition to ia for EFS"
  type        = string
}

variable "wordpress_secret_keys" {
  description = "Labels for authentication unique keys and salts for wp-config.php"
  type        = list(string)
}

/* 
  ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ env=specific configuration variables                                                                             │
  └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/

variable "owner" {
  description = "Owner username"
  type        = string
}

variable "project" {
  description = "Project we're working on"
  type        = string
}

variable "environment" {
  description = "Infra environment"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment could be one of dev | staging | prod"
  }
}
