output "id" {
  description = "The identifier for the resource with format projects/{{project}}/locations/global/keys/{{name}}"
  value       = google_apikeys_key.api_key.id
}

output "key_string" {
  description = "The encrypted and signed value held by this key (sensitive)"
  value       = google_apikeys_key.api_key.key_string
  sensitive   = true
}

output "uid" {
  description = "Unique ID in UUID4 format"
  value       = google_apikeys_key.api_key.uid
}

output "name" {
  description = "The resource name of the key"
  value       = google_apikeys_key.api_key.name
}

output "display_name" {
  description = "Human-readable display name of the API key"
  value       = google_apikeys_key.api_key.display_name
}

output "project" {
  description = "The project ID where the API key was created"
  value       = google_apikeys_key.api_key.project
}

output "secret_manager_secret_id" {
  description = "The ID of the Secret Manager secret (if created)"
  value       = var.secret_manager_config != null ? google_secret_manager_secret.api_key_secret[0].secret_id : null
}

output "secret_manager_secret_name" {
  description = "The full name of the Secret Manager secret (if created)"
  value       = var.secret_manager_config != null ? google_secret_manager_secret.api_key_secret[0].name : null
}

output "secret_manager_version_name" {
  description = "The full name of the Secret Manager secret version (if created)"
  value       = var.secret_manager_config != null ? google_secret_manager_secret_version.api_key_version[0].name : null
}
