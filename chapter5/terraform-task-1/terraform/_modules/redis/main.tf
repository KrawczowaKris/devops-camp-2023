module "redis" {
  source = "../container"
  
  container_image = var.container_image
  container_image_keep_locally = var.container_image_keep_locally
  container_name = var.container_name
  
  container_ports = {
    internal = var.container_ports.internal
    external = var.container_ports.external
  }
}
