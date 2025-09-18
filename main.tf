
# Enable API Keys API if requested
resource "google_project_service" "apikeys_api" {
  count   = var.enable_apis ? 1 : 0
  project = var.project_id
  service = "apikeys.googleapis.com"

  disable_on_destroy = var.disable_services_on_destroy
}

# Enable Secret Manager API if secret storage is requested
resource "google_project_service" "secretmanager_api" {
  count   = var.secret_manager_config != null && var.enable_apis ? 1 : 0
  project = var.project_id
  service = "secretmanager.googleapis.com"

  disable_on_destroy = var.disable_services_on_destroy
}

# Create the API key
resource "google_apikeys_key" "api_key" {
  name         = var.name
  display_name = var.display_name
  project      = var.project_id

  # Service account binding (optional)
  service_account_email = var.service_account_email

  # Key restrictions
  dynamic "restrictions" {
    for_each = var.restrictions != null ? [var.restrictions] : []

    content {
      # Android app restrictions
      dynamic "android_key_restrictions" {
        for_each = restrictions.value.android_key_restrictions != null ? [restrictions.value.android_key_restrictions] : []

        content {
          dynamic "allowed_applications" {
            for_each = android_key_restrictions.value.allowed_applications

            content {
              package_name      = allowed_applications.value.package_name
              sha1_fingerprint = allowed_applications.value.sha1_fingerprint
            }
          }
        }
      }

      # iOS app restrictions
      dynamic "ios_key_restrictions" {
        for_each = restrictions.value.ios_key_restrictions != null ? [restrictions.value.ios_key_restrictions] : []

        content {
          allowed_bundle_ids = ios_key_restrictions.value.allowed_bundle_ids
        }
      }

      # Browser/HTTP referrer restrictions
      dynamic "browser_key_restrictions" {
        for_each = restrictions.value.browser_key_restrictions != null ? [restrictions.value.browser_key_restrictions] : []

        content {
          allowed_referrers = browser_key_restrictions.value.allowed_referrers
        }
      }

      # Server/IP restrictions
      dynamic "server_key_restrictions" {
        for_each = restrictions.value.server_key_restrictions != null ? [restrictions.value.server_key_restrictions] : []

        content {
          allowed_ips = server_key_restrictions.value.allowed_ips
        }
      }

      # API service and method restrictions
      dynamic "api_targets" {
        for_each = restrictions.value.api_targets != null ? restrictions.value.api_targets : []

        content {
          service = api_targets.value.service
          methods = api_targets.value.methods
        }
      }
    }
  }

  depends_on = [google_project_service.apikeys_api]

  timeouts {
    create = var.timeout_create
    update = var.timeout_update
    delete = var.timeout_delete
  }
}

# Create Secret Manager secret if requested
resource "google_secret_manager_secret" "api_key_secret" {
  count     = var.secret_manager_config != null ? 1 : 0
  project   = var.project_id
  secret_id = var.secret_manager_config.secret_id

  labels = var.secret_manager_config.labels

  replication {
    user_managed {
      dynamic "replicas" {
        for_each = var.secret_manager_config.replica_locations != null ? var.secret_manager_config.replica_locations : ["us-central1"]
        content {
          location = replicas.value
        }
      }
    }
  }

  depends_on = [google_project_service.secretmanager_api]
}

# Store the API key in Secret Manager
resource "google_secret_manager_secret_version" "api_key_version" {
  count       = var.secret_manager_config != null ? 1 : 0
  secret      = google_secret_manager_secret.api_key_secret[0].id
  secret_data = google_apikeys_key.api_key.key_string

  depends_on = [google_secret_manager_secret.api_key_secret]
}