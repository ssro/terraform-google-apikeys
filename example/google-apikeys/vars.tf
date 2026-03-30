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
}

variable "display_name" {
  description = "Human-readable name for the key in the Google Cloud Console."
  type        = string
  default     = null
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
variable "enable_secret_manager" {
  description = "If set to true, the API key string will be stored in Google Secret Manager."
  type        = bool
  default     = false
}
