output "admin_password_rds" {
  sensitive   = true
  description = "Password for RDS admin"
  value       = random_password.rds_admin_password.result
}

output "instance_ids" {
  description = "List of created instance id"
  value       = module.wordpress_ec2[*].id
}

output "efs_id" {
  description = "ID of EFS"
  value       = module.wordpress_efs.id
}

output "alb_url" {
  description = "URL of ALB"
  value       = module.wordpress_alb.lb_dns_name
}

output "fqdn_record" {
  description = "FQDN record for ALB"
  value       = aws_route53_record.a_record_for_alb.fqdn
}
