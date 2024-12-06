# modules/nginx/docker/main.tf
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.0"
    }
  }
}

resource "docker_image" "nginx" {
  name = "nginx-prf:latest"
  build {
    context    = "."
    dockerfile = "Dockerfile_nginx"
    tag        = ["nginx-prf:latest"]
    no_cache   = true
  }
}

resource "docker_container" "nginx" {
  name  = "${var.container_name}"
  hostname = "${var.container_name}"
  image = docker_image.nginx.image_id

  # Port mapping
  ports {
    internal = var.app_port
    external = var.app_port
  }

  # Hálózat csatlakozás
  networks_advanced {
    name = "${var.project_name}-network"
    ipv4_address = "172.100.0.50"
  }
}

output "container_name" {
  value = var.container_name
}
