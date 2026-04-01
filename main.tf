locals {
  key_name = var.name_suffix != null ? "${var.name_prefix}-${var.name_suffix}" : var.name_prefix

  restriction_count = (
    (var.browser_key_restrictions != null ? 1 : 0) +
    (var.server_key_restrictions != null ? 1 : 0) +
    (length(var.android_key_restrictions) > 0 ? 1 : 0) +
    (var.ios_key_restrictions != null ? 1 : 0)
  )

  secret_id = var.secret_manager_secret_id != null ? var.secret_manager_secret_id : local.key_name
}

# Validate that at most one platform restriction type is set.
# Placed on a dummy resource check via a precondition on the key resource below.

# Enable API Keys API
resource "google_project_service" "apikeys" {
  count   = var.enable_apis ? 1 : 0
  project = var.project
  service = "apikeys.googleapis.com"

  disable_on_destroy = var.disable_services_on_destroy
}

# Enable Secret Manager API if needed
resource "google_project_service" "secretmanager" {
  count   = var.enable_apis && var.enable_secret_manager ? 1 : 0
  project = var.project
  service = "secretmanager.googleapis.com"

  disable_on_destroy = var.disable_services_on_destroy
}

resource "google_apikeys_key" "this" {
  name                  = local.key_name
  display_name          = var.display_name
  project               = var.project
  service_account_email = var.service_account_email

  lifecycle {
    precondition {
      condition     = local.restriction_count <= 1
      error_message = "Only one of browser_key_restrictions, server_key_restrictions, android_key_restrictions, or ios_key_restrictions may be set at a time."
    }

    precondition {
      condition     = can(regex("^[a-z]([a-z0-9-]{0,61}[a-z0-9])?$", local.key_name))
      error_message = "The constructed key name \"${local.key_name}\" does not match the required pattern [a-z]([a-z0-9-]{0,61}[a-z0-9])?. Check name_prefix and name_suffix."
    }
  }

  dynamic "restrictions" {
    for_each = local.restriction_count > 0 || length(var.api_targets) > 0 ? [1] : []

    content {
      dynamic "browser_key_restrictions" {
        for_each = var.browser_key_restrictions != null ? [var.browser_key_restrictions] : []
        content {
          allowed_referrers = browser_key_restrictions.value.allowed_referrers
        }
      }

      dynamic "server_key_restrictions" {
        for_each = var.server_key_restrictions != null ? [var.server_key_restrictions] : []
        content {
          allowed_ips = server_key_restrictions.value.allowed_ips
        }
      }

      dynamic "android_key_restrictions" {
        for_each = length(var.android_key_restrictions) > 0 ? [var.android_key_restrictions] : []
        content {
          dynamic "allowed_applications" {
            for_each = android_key_restrictions.value
            content {
              package_name     = allowed_applications.value.package_name
              sha1_fingerprint = allowed_applications.value.sha1_fingerprint
            }
          }
        }
      }

      dynamic "ios_key_restrictions" {
        for_each = var.ios_key_restrictions != null ? [var.ios_key_restrictions] : []
        content {
          allowed_bundle_ids = ios_key_restrictions.value.allowed_bundle_ids
        }
      }

      dynamic "api_targets" {
        for_each = var.api_targets
        content {
          service = api_targets.value.service
          methods = api_targets.value.methods
        }
      }
    }
  }

  depends_on = [google_project_service.apikeys]

  timeouts {
    create = var.timeout_create
    update = var.timeout_update
    delete = var.timeout_delete
  }
}

resource "google_secret_manager_secret" "this" {
  count     = var.enable_secret_manager ? 1 : 0
  project   = var.project
  secret_id = local.secret_id
  labels    = var.secret_manager_labels

  replication {
    user_managed {
      dynamic "replicas" {
        for_each = var.secret_manager_replica_locations
        content {
          location = replicas.value
        }
      }
    }
  }

  depends_on = [google_project_service.secretmanager]
}

resource "google_secret_manager_secret_version" "this" {
  count       = var.enable_secret_manager ? 1 : 0
  secret      = google_secret_manager_secret.this[0].id
  secret_data = google_apikeys_key.this.key_string
}
