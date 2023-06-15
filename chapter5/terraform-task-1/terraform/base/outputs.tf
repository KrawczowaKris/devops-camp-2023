output "nginx" {
  description = "Nginx configuration"
  value       = var.use_nginx ? module.nginx[*].nginx : []
}

output "redis" {
  description = "Redis configuration"
  value       = var.use_redis ? module.redis[*].redis : []
}
