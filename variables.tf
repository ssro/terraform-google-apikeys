variable "name" {
  description = "The resource name of the key. Must be unique within the project, conform with RFC-1034, and match [a-z]([a-z0-9-]{0,61}[a-z0-9])?"
  type        = string

  validation {
    condition     = can(regex("^[a-z]([a-z0-9-]{0,61}[a-z0-9])?$", var.name))
    error_message = "The name must match the regular expression: [a-z]([a-z0-9-]{0,61}[a-z0-9])?."
  }
}

variable "display_name" {
  description = "Human-readable display name of this API key"
  type        = string
  default     = null
}

variable "project_id" {
  description = "The project ID where the API key will be created"
  type        = string
}

variable "service_account_email" {
  description = "Email of the service account the key is bound to. If specified, the key is a service account bound key"
  type        = string
  default     = null
}

variable "enable_apis" {
  description = "Whether to enable the API Keys API"
  type        = bool
  default     = true
}

variable "disable_services_on_destroy" {
  description = "Whether to disable the API when the resource is destroyed"
  type        = bool
  default     = false
}

variable "restrictions" {
  description = "Key restrictions configuration"
  type = object({
    android_key_restrictions = optional(object({
      allowed_applications = list(object({
        package_name      = string
        sha1_fingerprint = string
      }))
    }))

    ios_key_restrictions = optional(object({
      allowed_bundle_ids = list(string)
    }))

    browser_key_restrictions = optional(object({
      allowed_referrers = list(string)
    }))

    server_key_restrictions = optional(object({
      allowed_ips = list(string)
    }))

    api_targets = optional(list(object({
      service = string
      methods = optional(list(string))
    })))
  })
  default = null
}

variable "timeout_create" {
  description = "Timeout for create operations"
  type        = string
  default     = "20m"
}

variable "timeout_update" {
  description = "Timeout for update operations"
  type        = string
  default     = "20m"
}

variable "timeout_delete" {
  description = "Timeout for delete operations"
  type        = string
  default     = "20m"
}

variable "secret_manager_config" {
  description = "Configuration for storing the API key in Secret Manager"
  type = object({
    secret_id         = string
    replica_locations = optional(list(string))
    labels           = optional(map(string))
  })
  default = null

  validation {
    condition = var.secret_manager_config == null || (
    var.secret_manager_config != null &&
    can(regex("^[a-zA-Z0-9_-]+$", var.secret_manager_config.secret_id)) &&
    length(var.secret_manager_config.secret_id) >= 1 &&
    length(var.secret_manager_config.secret_id) <= 255
    )
    error_message = "The secret_id must be 1-255 characters and contain only letters, numbers, hyphens, and underscores."
  }
}
