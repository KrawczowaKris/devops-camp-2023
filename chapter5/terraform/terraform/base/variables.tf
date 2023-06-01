variable "cache_dns" {
  description = "Name of domen for site"
  type        = string
}

variable "cache_vpc_tags" {
  description = "VPC tags to place cache host into"
  type        = map(string)
  default = {
    Name = "default"
  }
}

variable "cache_availability_zones" {
  description = "Instance Availability Zones of the Cache host"
  type        = list(string)
}

variable "cache_engine" {
  description = "ElastiCache Engine, like redis"
  type        = string
}

variable "cache_array_index_ec2" {
  description = "Array of index for ec2 instances"
  type        = list(string)
}

variable "cache_instance_ec2_type" {
  description = "Type of instance ec2"
  type        = string
}

variable "cache_ami_id" {
  description = "ID of AMI type for ec2 instance"
  type        = string
}

variable "cache_ingress_rules_rds" {
  description = "Ingress rules for rds instances"
  type        = list(map(string))
}

variable "cache_ingress_rules_alb" {
  description = "Ingress rules for alb"
  type        = list(map(string))
}

variable "cache_egress_rules" {
  description = "Egress rules for ec2 instances"
  type        = list(map(string))
}

variable "cache_mount_targets_efs" {
  description = "List of subnets for EFS"
  type        = any
}

variable "cache_instance_rds_class" {
  description = "Type of instance rds class"
  type        = string
}

variable "cache_rds_major_engine_version" {
  description = "Database major engine version"
  type        = string
}

variable "cache_rds_name" {
  description = "Name of RDS"
  type        = string
}

variable "cache_storage_type" {
  description = "Type of storage for RDS"
  type        = string
}

variable "cache_allocated_storage" {
  description = "Amount of allocated storage for RDS"
  type        = string
}

variable "cache_list_labels_random_values" {
  description = "Label for authentication unique keys and salts for wp-config.php"
  type        = list(string)
}

/* 
  ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ env=specific configuration variables                                                                             │
  └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
 */

variable "client" {
  description = "Client username"
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
