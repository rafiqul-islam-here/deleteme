variable "location" {
  description = "The Azure region where resources will be created."
  type        = string
  default     = "East US"
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
  default     = "rg-deleteme"
}

variable "app_service_plan_name" {
  description = "The name of the App Service Plan."
  type        = string
  default     = "asp-deleteme"
}

variable "web_app_name" {
  description = "The base name of the Linux Web App."
  type        = string
  default     = "app-deleteme"
}

variable "postgres_server_name" {
  description = "The base name of the PostgreSQL Flexible Server."
  type        = string
  default     = "db-deleteme"
}

variable "db_username" {
  description = "The administrator username for the PostgreSQL database server."
  type        = string
  default     = "dbadmin"
}

variable "db_password" {
  description = "The administrator password for the PostgreSQL database server."
  type        = string
  sensitive   = true
  default     = "P@ssw0rd12345!"
}

variable "db_name" {
  description = "The name of the initial database to create."
  type        = string
  default     = "school"
}
