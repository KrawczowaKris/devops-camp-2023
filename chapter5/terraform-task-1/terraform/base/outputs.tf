output "nginx" {
  description = "Nginx configuration"
  value = var.use_nginx ? {
    container_id       = module.nginx[0].nginx.id
    container_id_short = substr(module.nginx[0].nginx.id, 0, 12)
    image_id           = module.nginx[0].nginx.image_id
  } : {}
}

output "redis" {
  description = "Redis configuration"
  value = var.use_redis ? {
    container_id       = module.redis[0].redis.id
    container_id_short = substr(module.redis[0].redis.id, 0, 12)
    image_id           = module.redis[0].redis.image_id
  } : {}
}
