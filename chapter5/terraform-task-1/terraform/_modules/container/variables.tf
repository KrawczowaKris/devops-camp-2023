variable "image" {
  description = "Value of the name for the Docker container"
  type        = string
}

variable "image_keep_locally" {
  description = "If true, then the Docker image won't be deleted on destroy operation. If this is false, it will delete the image from the docker local storage on destroy operation."
  type        = bool
}

variable "name" {
  description = "Value of the name for the Docker container"
  type        = string
}

variable "ports" {
  description = "Value of the name for the Docker container"

  type = object({
    internal = number
    external = number
  })
}

variable "volumes" {
  description = "List fo volumes for docker container"

  type = list(object({
    volumes_host_path      = string
    volumes_container_path = string
  }))

  default = [
    {
      volumes_host_path      = ""
      volumes_container_path = ""
    }
  ]
}
