terraform {
  required_version = ">= 1.3.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Generate a random string to guarantee resource name uniqueness
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# 1. Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# 2. App Service Plan (Linux)
resource "azurerm_service_plan" "asp" {
  name                = var.app_service_plan_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "B1" # Cost-effective tier with custom domains and SSL
}

# 3. PostgreSQL Flexible Server
resource "azurerm_postgresql_flexible_server" "postgres" {
  name                   = "${var.postgres_server_name}-${random_string.suffix.result}"
  resource_group_name    = azurerm_resource_group.rg.name
  location               = azurerm_resource_group.rg.location
  version                = "16"
  administrator_login    = var.db_username
  administrator_password = var.db_password
  storage_mb             = 32768
  sku_name               = "B_Standard_B1ms" # Burstable tier for cost efficiency

  lifecycle {
    ignore_changes = [
      zone,
    ]
  }
}

# 4. PostgreSQL Database
resource "azurerm_postgresql_flexible_server_database" "db" {
  name      = var.db_name
  server_id = azurerm_postgresql_flexible_server.postgres.id
  collation = "en_US.utf8"
}

# 5. PostgreSQL Firewall Rule (Allow Azure Services access)
resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_azure_services" {
  name             = "AllowAzureServices"
  server_id        = azurerm_postgresql_flexible_server.postgres.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

# 6. Linux Web App with Docker Compose
resource "azurerm_linux_web_app" "web_app" {
  name                = "${var.web_app_name}-${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {
    application_stack {
      # Use COMPOSE| followed by the base64-encoded docker-compose-azure.yml file
      docker_image_name = "COMPOSE|${base64encode(file("${path.module}/../docker-compose-azure.yml"))}"
      # Provide fallback URL for pulling images if any public layers are required
      docker_registry_url = "https://ghcr.io"
    }
  }

  app_settings = {
    # Application settings mapping to container environment variables
    "DB_HOST"                             = azurerm_postgresql_flexible_server.postgres.fqdn
    "DB_PORT"                             = "5432"
    "DB_NAME"                             = var.db_name
    "DB_USER"                             = var.db_username
    "DB_PASSWORD"                         = var.db_password
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
    "DOCKER_ENABLE_CI"                    = "true"
  }

  depends_on = [
    azurerm_postgresql_flexible_server_database.db,
    azurerm_postgresql_flexible_server_firewall_rule.allow_azure_services
  ]
}
