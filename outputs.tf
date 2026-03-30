output "key_id" {
  description = "The resource name of the key (projects/PROJECT_NUMBER/locations/global/keys/KEY_ID)."
  value       = google_apikeys_key.this.id
}

output "key_uid" {
  description = "The unique UUID4 identifier for the key."
  value       = google_apikeys_key.this.uid
}

output "key_string" {
  description = "The raw API key string (Sensitive)."
  value       = google_apikeys_key.this.key_string
  sensitive   = true
}

output "secret_name" {
  description = "The name of the secret in Secret Manager (if enabled)."
  value       = var.enable_secret_manager ? google_secret_manager_secret.key_vault[0].name : null
}

output "secret_version" {
  description = "The specific version resource name (if enabled)."
  value       = var.enable_secret_manager ? google_secret_manager_secret_version.key_version[0].name : null
}
output "display_name" {
  value = google_apikeys_key.this.display_name
}
