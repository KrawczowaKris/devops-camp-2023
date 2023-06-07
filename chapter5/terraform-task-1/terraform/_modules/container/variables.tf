variable "container_image" {
  description = "Value of the name for the Docker container"
  type        = string
}

variable "container_image_keep_locally" {
  description = "If true, then the Docker image won't be deleted on destroy operation. If this is false, it will delete the image from the docker local storage on destroy operation."
  type        = bool
}

variable "container_name" {
  description = "Value of the name for the Docker container"
  type        = string
}

variable "container_ports" {
  description = "Value of the name for the Docker container"
  type        = map(any)
}

variable "volumes_host_path" {
  description = "Path to volume host"
  type = string
  default = ""
}

variable "volumes_container_path" {
  description = "Path to volume container"
  type = string
  default = ""
}

variable "provisioner" {
  description = "List of provisioners for container"
  type = map(any)
}
