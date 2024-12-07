# modules/graylog/main.tf
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.0"
    }
  }
}

# Create volumes
resource "docker_volume" "mongodb_data" {
  name = "mongodb_data"
}

resource "docker_volume" "graylog_datanode" {
  name = "graylog-datanode"
}

resource "docker_volume" "graylog_data" {
  name = "graylog_data"
}

resource "docker_volume" "graylog_journal" {
  name = "graylog_journal"
}

# MongoDB Container
resource "docker_container" "mongodb" {
  name  = "mongodb"
  image = "mongo:5.0"
  
  networks_advanced {
    name = "${var.project_name}-network"
    ipv4_address = "172.100.0.15"
  }

  volumes {
    volume_name    = docker_volume.mongodb_data.name
    container_path = "/data/db"
  }

  restart = "on-failure"
}

# Datanode Container
resource "docker_container" "datanode" {
  name     = "datanode"
  image    = var.datanode_image
  hostname = "datanode"

  networks_advanced {
    name = "${var.project_name}-network"
    ipv4_address = "172.100.0.11"
  }

  env = [
    "GRAYLOG_DATANODE_NODE_ID_FILE=/var/lib/graylog-datanode/node-id",
    "GRAYLOG_DATANODE_PASSWORD_SECRET=${var.graylog_password_secret}",
    "GRAYLOG_DATANODE_ROOT_PASSWORD_SHA2=${var.graylog_root_password_sha2}",
    "GRAYLOG_DATANODE_MONGODB_URI=mongodb://mongodb:27017/graylog"
  ]

  ulimit {
    name = "memlock"
    soft = -1
    hard = -1
  }

  ulimit {
    name = "nofile"
    soft = 65536
    hard = 65536
  }

  ports {
    internal = 8999
    external = 8999
  }

  ports {
    internal = 9200
    external = 9200
  }

  ports {
    internal = 9300
    external = 9300
  }

  volumes {
    volume_name    = docker_volume.graylog_datanode.name
    container_path = "/var/lib/graylog-datanode"
  }

  restart = "on-failure"
}

# Graylog Server Container
resource "docker_container" "graylog" {
  name     = "graylog"
  image    = var.graylog_image
  hostname = "server"

  networks_advanced {
    name = "${var.project_name}-network"
    ipv4_address = "172.100.0.12"
  }

  env = [
    "GRAYLOG_NODE_ID_FILE=/usr/share/graylog/data/data/node-id",
    "GRAYLOG_PASSWORD_SECRET=${var.graylog_password_secret}",
    "GRAYLOG_ROOT_PASSWORD_SHA2=${var.graylog_root_password_sha2}",
    "GRAYLOG_HTTP_BIND_ADDRESS=0.0.0.0:9000",
    "GRAYLOG_HTTP_EXTERNAL_URI=http://localhost:9000/",
    "GRAYLOG_MONGODB_URI=mongodb://mongodb:27017/graylog"
  ]

  entrypoint = ["/usr/bin/tini", "--", "/docker-entrypoint.sh"]

  ports {
    internal = 5044
    external = 5044
  }

  ports {
    internal = 5140
    external = 5140
    protocol = "udp"
  }

  ports {
    internal = 5140
    external = 5140
    protocol = "tcp"
  }

  ports {
    internal = 5555
    external = 5555
    protocol = "tcp"
  }

  ports {
    internal = 5555
    external = 5555
    protocol = "udp"
  }

  ports {
    internal = 9000
    external = 9000
  }

  ports {
    internal = 12201
    external = 12201
    protocol = "tcp"
  }

  ports {
    internal = 12201
    external = 12201
    protocol = "udp"
  }

  ports {
    internal = 13301
    external = 13301
  }

  ports {
    internal = 13302
    external = 13302
  }

  volumes {
    volume_name    = docker_volume.graylog_data.name
    container_path = "/usr/share/graylog/data/data"
  }

  volumes {
    volume_name    = docker_volume.graylog_journal.name
    container_path = "/usr/share/graylog/data/journal"
  }

  restart = "on-failure"

  depends_on = [
    docker_container.mongodb,
    docker_container.datanode
  ]
}