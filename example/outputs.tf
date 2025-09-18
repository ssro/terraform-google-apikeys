# Comprehensive API Key Outputs
output "comprehensive_api_key_id" {
  description = "The ID of the comprehensive API key"
  value       = module.comprehensive_api_key.id
}

output "comprehensive_api_key_name" {
  description = "The name of the comprehensive API key"
  value       = module.comprehensive_api_key.name
}

output "comprehensive_api_key_uid" {
  description = "The unique ID of the comprehensive API key"
  value       = module.comprehensive_api_key.uid
}

# Note: The actual key string is sensitive and should be handled carefully
output "comprehensive_api_key_string" {
  description = "The actual API key string (sensitive)"
  value       = module.comprehensive_api_key.key_string
  sensitive   = true
}

# Secret Manager outputs for comprehensive key
output "comprehensive_secret_manager_secret_name" {
  description = "The Secret Manager secret name where comprehensive API key is stored"
  value       = module.comprehensive_api_key.secret_manager_secret_name
}

output "comprehensive_secret_manager_version_name" {
  description = "The Secret Manager secret version name for comprehensive key"
  value       = module.comprehensive_api_key.secret_manager_version_name
}

# Android Key Outputs
output "android_api_key_id" {
  description = "The ID of the Android API key"
  value       = module.android_only_key.id
}

output "android_secret_manager_secret_name" {
  description = "The Secret Manager secret name for Android API key"
  value       = module.android_only_key.secret_manager_secret_name
}

# Web App Key Outputs
output "web_app_api_key_id" {
  description = "The ID of the web application API key"
  value       = module.web_app_key.id
}

output "web_app_secret_manager_secret_name" {
  description = "The Secret Manager secret name for web app API key"
  value       = module.web_app_key.secret_manager_secret_name
}

# Server Key Outputs
output "server_api_key_id" {
  description = "The ID of the server API key"
  value       = module.server_key.id
}

output "server_secret_manager_secret_name" {
  description = "The Secret Manager secret name for server API key"
  value       = module.server_key.secret_manager_secret_name
}

# iOS Key Outputs
output "ios_api_key_id" {
  description = "The ID of the iOS API key"
  value       = module.ios_key.id
}

output "ios_secret_manager_secret_name" {
  description = "The Secret Manager secret name for iOS API key"
  value       = module.ios_key.secret_manager_secret_name
}

# Minimal Key Output (no Secret Manager)
output "minimal_api_key_id" {
  description = "The ID of the minimal API key"
  value       = module.minimal_api_key.id
}

# Summary of all created secrets
output "all_secret_manager_secrets" {
  description = "Map of all Secret Manager secrets created"
  value = {
    comprehensive = module.comprehensive_api_key.secret_manager_secret_name
    android       = module.android_only_key.secret_manager_secret_name
    web_app       = module.web_app_key.secret_manager_secret_name
    server        = module.server_key.secret_manager_secret_name
    ios           = module.ios_key.secret_manager_secret_name
  }
}
