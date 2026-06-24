output "web_app_url" {
  description = "The default public hostname of the deployed Web App."
  value       = "https://${azurerm_linux_web_app.web_app.default_hostname}"
}

output "postgres_fqdn" {
  description = "The fully qualified domain name of the PostgreSQL server."
  value       = azurerm_postgresql_flexible_server.postgres.fqdn
}
