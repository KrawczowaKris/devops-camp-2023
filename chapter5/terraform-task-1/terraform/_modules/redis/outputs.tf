output "container_id" {
  description = "ID of the Docker container"
  value       = module.redis.id
}

output "container_id_short" {
  description = "Short ID of the Docker container"
  value       = substr(module.redis.id, 0, 12)
}

output "image_id" {
  description = "ID of the Docker image"
  value = module.redis.image_id
}
