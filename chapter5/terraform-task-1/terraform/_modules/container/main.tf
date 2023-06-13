resource "docker_image" "image" {
  name         = var.image
  keep_locally = var.image_keep_locally
}

resource "docker_container" "container" {
  image = docker_image.image.image_id
  name  = var.name

  ports {
    internal = var.ports.internal
    external = var.ports.external
  }

  dynamic "volumes" {
    for_each = var.volumes

    content {
      host_path      = volumes.value.volumes_host_path
      container_path = volumes.value.volumes_container_path
    }
  }

  provisioner "local-exec" {
    command     = "${path.root}/terraform/_modules/container/deleting_pages.sh"
    when        = destroy
    working_dir = path.root #var.provisioner.working_dir
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
  #     environment = provisioner.value.environment
  #   }
  # }
}
