variable "ip_address" {
  description = "Corporate IP address"
  type        = string
}

variable "wordpress_instances_count" {
  description = "Number of instances ec2"
  type        = number
}

variable "dns_name" {
  description = "Name of domen for site"
  type        = string
}

variable "vpc_tags" {
  description = "VPC tags to place host into"
  type        = map(string)
  default = {
    Name = "default"
  }
}

variable "availability_zones" {
  description = "Instance Availability Zones of the host"
  type        = list(string)
}

variable "instance_ec2_type" {
  description = "Type of instance ec2"
  type        = string
}

variable "instance_ami_id" {
  description = "ID of AMI type for ec2 instance"
  type        = string
}

variable "instance_rds_class" {
  description = "Type of instance rds class"
  type        = string
}

variable "rds_major_engine_version" {
  description = "Database major engine version"
  type        = string
}

variable "rds_name" {
  description = "Name of RDS"
  type        = string
}

variable "rds_storage_type" {
  description = "Type of storage for RDS"
  type        = string
}

variable "rds_allocated_storage" {
  description = "Amount of allocated storage for RDS"
  type        = string
}

variable "rds_backup_window" {
  description = "Backup window for RDS"
  type = string
}

variable "rds_maintenance_window" {
  description = "Maintenance window for RDS"
  type = string
}

variable "rds_engine" {
  description = "Engine for RDS"
  type = string
}

variable "list_labels_random_values" {
  description = "Label for authentication unique keys and salts for wp-config.php"
  type        = list(string)
}

variable "efs_throughput_mode" {
  description = "Throughput mode for EFS"
  type = string
}

variable "efs_transition_to_ia" {
  description = "Transition to ia for EFS"
  type = string
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

variable "tags" {
  description = "tags for the resource"
  type        = map(any)
}
