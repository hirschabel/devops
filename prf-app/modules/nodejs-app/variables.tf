# modules/nodejs-app/docker/variables.tf
variable "project_name" {
  description = "A projekt neve, ami az erőforrások elnevezésében is megjelenik"
  type        = string
  default     = "prf-project"
}

variable "container_name" {
  description = "A Docker konténer neve"
  type        = string
}

variable "app_port" {
  description = "Az alkalmazás portja"
  type        = number
  default     = 5000
}

variable "image_tag" {
  description = "Docker image tag"
  type        = string
  default     = "latest"
}
