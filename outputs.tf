output "key_id" {
  description = "Full resource ID of the API key (projects/.../locations/global/keys/...)."
  value       = google_apikeys_key.this.id
}

output "key_string" {
  description = "Raw API key value."
  value       = google_apikeys_key.this.key_string
  sensitive   = true
}

output "key_uid" {
  description = "Unique ID of the key in UUID4 format."
  value       = google_apikeys_key.this.uid
}

output "key_name" {
  description = "The constructed resource name of the key (prefix[-suffix])."
  value       = google_apikeys_key.this.name
}

output "display_name" {
  description = "Human-readable display name of the key."
  value       = google_apikeys_key.this.display_name
}

output "secret_manager_secret_id" {
  description = "The Secret Manager secret ID (if enable_secret_manager = true)."
  value       = var.enable_secret_manager ? google_secret_manager_secret.this[0].secret_id : null
}

output "secret_manager_secret_name" {
  description = "The full Secret Manager secret name (if enable_secret_manager = true)."
  value       = var.enable_secret_manager ? google_secret_manager_secret.this[0].name : null
}

output "secret_manager_version_name" {
  description = "The full Secret Manager secret version name (if enable_secret_manager = true)."
  value       = var.enable_secret_manager ? google_secret_manager_secret_version.this[0].name : null
}
