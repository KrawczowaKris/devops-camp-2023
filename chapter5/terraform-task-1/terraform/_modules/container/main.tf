resource "docker_image" "image" {
  name         = var.container_image
  keep_locally = var.container_image_keep_locally
}

resource "docker_container" "container" {
  image = docker_image.image.image_id
  name = var.container_name

  ports {
    internal = var.container_ports.internal
    external = var.container_ports.external
  }

  volumes {
    host_path = var.volumes_host_path
    container_path = var.volumes_container_path
  }

  provisioner "local-exec" {
    command     = "${path.root}/terraform/_modules/container/deleting_pages.sh"
    when        = destroy
    working_dir = path.root  #var.provisioner.working_dir
    # environment = {
    #   folder_name = "dev"
    # }
 } 

  # dynamic provisioner {
  #   for_each = var.provisioners

  #   content {
  #     type        = provisioner.value.type
  #     command     = provisioner.value.command
  #     when        = provisioner.value.when
  #     working_dir = provisioner.value.working_dir
  #     #environment = provisioner.value.environment
  #   }
  # }
}
