output "nginx" {
  description = "Nginx configuration"
  value       = var.use_nginx ? module.nginx[0].nginx : {}
}

output "redis" {
  description = "Redis configuration"
  value       = var.use_redis ? module.redis[0].redis : {}
}
