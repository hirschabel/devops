variable "zabbix_mysql_password" {
  description = "Password for Zabbix MySQL user"
  type        = string
  default     = "zabbix_pwd"
}

variable "mysql_root_password" {
  description = "Root password for MySQL"
  type        = string
  default     = "root_pwd"
}

variable "project_name" {
  description = "A projekt neve, ami az erőforrások elnevezésében is megjelenik"
  type        = string
  default     = "prf-project"
}