# ---------------------------------------------------------------------------------------------------------------------
# API KEY RESOURCE
# ---------------------------------------------------------------------------------------------------------------------
resource "google_apikeys_key" "this" {
  # Logic: If suffix is provided, name is "prefix-suffix". If null, name is just "prefix".
  name         = var.name_suffix != null ? "${var.name_prefix}-${var.name_suffix}" : var.name_prefix
  display_name = var.display_name
  project      = var.project

  restrictions {
    # Browser (Web) Restrictions
    dynamic "browser_key_restrictions" {
      for_each = var.browser_key_restrictions != null ? [var.browser_key_restrictions] : []
      content {
        allowed_referrers = browser_key_restrictions.value.allowed_referrers
      }
    }

    # Server (IP) Restrictions
    dynamic "server_key_restrictions" {
      for_each = var.server_key_restrictions != null ? [var.server_key_restrictions] : []
      content {
        allowed_ips = server_key_restrictions.value.allowed_ips
      }
    }

    # Android Restrictions
    dynamic "android_key_restrictions" {
      for_each = length(var.android_key_restrictions) > 0 ? [1] : []
      content {
        dynamic "allowed_applications" {
          for_each = var.android_key_restrictions
          content {
            package_name     = allowed_applications.value.package_name
            sha1_fingerprint = allowed_applications.value.sha1_fingerprint
          }
        }
      }
    }

    # iOS Restrictions
    dynamic "ios_key_restrictions" {
      for_each = var.ios_key_restrictions != null ? [var.ios_key_restrictions] : []
      content {
        allowed_bundle_ids = ios_key_restrictions.value.allowed_bundle_ids
      }
    }

    # API Targets (Service/Method Scoping)
    dynamic "api_targets" {
      for_each = var.api_targets
      content {
        service = api_targets.value.service
        methods = api_targets.value.methods
      }
    }
  }

  lifecycle {
    # Ensures zero-downtime rotation by creating the new key before destroying the old one.
    create_before_destroy = true
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL SECRET MANAGER INTEGRATION
# ---------------------------------------------------------------------------------------------------------------------

# Create the Secret container ONLY if enabled
resource "google_secret_manager_secret" "key_vault" {
  count     = var.enable_secret_manager ? 1 : 0
  project   = var.project
  secret_id = "${var.name_prefix}-secret"

  replication {
    auto {}
  }
}

# Store the API Key string as a new version ONLY if enabled
resource "google_secret_manager_secret_version" "key_version" {
  count       = var.enable_secret_manager ? 1 : 0
  secret      = google_secret_manager_secret.key_vault[0].id
  secret_data = google_apikeys_key.this.key_string
  enabled     = true
}