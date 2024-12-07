variable "graylog_password_secret" {
  description = "Secret key for password encryption"
  type        = string
}

variable "graylog_root_password_sha2" {
  description = "SHA256 hash of the root password"
  type        = string
}

variable "datanode_image" {
  description = "Graylog datanode image"
  type        = string
  default     = "graylog/graylog-datanode:6.0"
}

variable "graylog_image" {
  description = "Graylog server image"
  type        = string
  default     = "graylog/graylog:6.0"
}

variable "project_name" {
  description = "A projekt neve, ami az erőforrások elnevezésében is megjelenik"
  type        = string
  default     = "prf-project"
}