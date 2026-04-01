variable "project" {
  description = "The GCP project ID where the key will be created."
  type        = string
}

variable "name_prefix" {
  description = "Prefix for the API key resource name."
  type        = string
}

variable "name_suffix" {
  description = "A version suffix (e.g., v1, v2). Changing this triggers a safe replacement/rotation."
  type        = string
  default     = null

  validation {
    condition     = var.name_suffix == null || can(regex("^[a-z0-9-]+$", var.name_suffix))
    error_message = "name_suffix must contain only lowercase letters, numbers, and hyphens."
  }
}

variable "display_name" {
  description = "Human-readable name for the key in the Google Cloud Console."
  type        = string
  default     = null
}

variable "labels" {
  description = "Labels to apply to the API key resource."
  type        = map(string)
  default     = {}
}

# --- Auth ---

variable "service_account_email" {
  description = "Email of the service account to bind the key to. Enables service account bound key auth."
  type        = string
  default     = null
}

# --- API enablement ---

variable "enable_apis" {
  description = "Whether to automatically enable apikeys.googleapis.com (and secretmanager.googleapis.com if needed)."
  type        = bool
  default     = true
}

variable "disable_services_on_destroy" {
  description = "Whether to disable the APIs when the module is destroyed."
  type        = bool
  default     = false
}

# --- Restrictions ---

variable "browser_key_restrictions" {
  description = "HTTP referrers (websites) allowed to use the key."
  type = object({
    allowed_referrers = list(string)
  })
  default = null
}

variable "server_key_restrictions" {
  description = "IP addresses (IPv4/IPv6 or CIDR) allowed to use the key."
  type = object({
    allowed_ips = list(string)
  })
  default = null
}

variable "android_key_restrictions" {
  description = "Android applications allowed to use the key."
  type = list(object({
    package_name     = string
    sha1_fingerprint = string
  }))
  default = []
}

variable "ios_key_restrictions" {
  description = "iOS bundle IDs allowed to use the key."
  type = object({
    allowed_bundle_ids = list(string)
  })
  default = null
}

variable "api_targets" {
  description = "Scope the key to specific Google Cloud APIs and methods."
  type = list(object({
    service = string
    methods = optional(list(string))
  }))
  default = []
}

# --- Secret Manager ---

variable "enable_secret_manager" {
  description = "If true, the API key string will be stored in Google Secret Manager."
  type        = bool
  default     = false
}

variable "secret_manager_secret_id" {
  description = "The Secret Manager secret ID to use. Defaults to the constructed key name."
  type        = string
  default     = null

  validation {
    condition     = var.secret_manager_secret_id == null || can(regex("^[a-zA-Z0-9_-]{1,255}$", var.secret_manager_secret_id))
    error_message = "secret_manager_secret_id must be 1-255 chars and contain only letters, numbers, hyphens, and underscores."
  }
}

variable "secret_manager_replica_locations" {
  description = "List of regions to replicate the secret to. Defaults to [\"us-central1\"]."
  type        = list(string)
  default     = ["us-central1"]
}

variable "secret_manager_labels" {
  description = "Labels to apply to the Secret Manager secret."
  type        = map(string)
  default     = {}
}

# --- Timeouts ---

variable "timeout_create" {
  description = "Timeout for create operations."
  type        = string
  default     = "20m"
}

variable "timeout_update" {
  description = "Timeout for update operations."
  type        = string
  default     = "20m"
}

variable "timeout_delete" {
  description = "Timeout for delete operations."
  type        = string
  default     = "20m"
}