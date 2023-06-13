locals {
  rendered_index_html = templatefile("${path.module}/templates/index.html.tftpl", {
    environment = var.environment,
    client      = var.client
  })
}

module "nginx" {
  source = "../container"

  image              = var.container_image
  image_keep_locally = var.container_image_keep_locally
  name               = var.container_name
  ports              = var.container_ports
  volumes            = var.volumes_nginx

  depends_on = [
    null_resource.create_index_page
  ]
}

resource "null_resource" "create_index_page" {
  provisioner "local-exec" {
    command = "mkdir ../../${var.environment} && cat > ../../${var.environment}/index.html  <<EOL\n${local.rendered_index_html}\nEOL"
  }
}

resource "null_resource" "destroy_index_page" {
  triggers = {
    name_folder = "../../${var.environment}"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "rm -rf '${self.triggers.name_folder}'"
  }
}
