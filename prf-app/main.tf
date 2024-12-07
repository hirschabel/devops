# main.tf
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.0"
    }
  }
}

# Közös hálózat létrehozása
resource "docker_network" "app_network" {
  name = "${var.project_name}-network"
  driver = "bridge"
  # Enable IPv6 if needed
  ipam_config {
    subnet = "172.100.0.0/16"  # Customize subnet as needed
    gateway = "172.100.0.1"
  }
  internal = false
}

# MongoDB modul
module "mongodb" {
  source = "./modules/mongodb"
  
  app_port = var.db_port
  container_name = "${var.project_name}-mongodb"
}

# NodeJS alkalmazás modul
module "nodejs_app" {
  source = "./modules/nodejs-app"
  
  app_port = var.server_port
  container_name = "${var.project_name}-nodejs"
}

# Angular alkalmazás modul
module "angular_app" {
  source = "./modules/angular-app"
  
  app_port = var.client_port
  container_name = "${var.project_name}-angular"
}

# Nginx modul
module "nginx" {
  source = "./modules/nginx"
  
  app_port = var.nginx_port
  container_name = "${var.project_name}-nginx"
}

# Zabbix modul
module "zabbix" {
  source = "./modules/zabbix"
  
  mysql_root_password = var.mysql_root_password
  zabbix_mysql_password = var.zabbix_mysql_password
}

# Graylog modul
module "graylog" {
  source = "./modules/graylog"
  
  graylog_password_secret    = var.graylog_password_secret
  graylog_root_password_sha2 = var.graylog_root_password_sha2
}