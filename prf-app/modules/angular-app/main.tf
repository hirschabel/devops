# modules/nodejs-app/docker/main.tf
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.0"
    }
  }
}

resource "docker_image" "angular_app" {
  name = "angular-prf:latest"
  build {
    context    = "."
    dockerfile = "Dockerfile_angular"
    tag        = ["angular-prf:latest"]
    no_cache   = true
  }
}

resource "docker_container" "angular_app" {
  name  = "${var.container_name}"
  hostname = "${var.container_name}"
  image = docker_image.angular_app.image_id
  
  # Port mapping
  ports {
    internal = var.app_port
    external = var.app_port
  }
  
  # Hálózat csatlakozás
  networks_advanced {
    name = "${var.project_name}-network"
    ipv4_address = "172.100.0.20"
  }
}

# Output a container_name használatához
output "container_name" {
  value = var.container_name
}