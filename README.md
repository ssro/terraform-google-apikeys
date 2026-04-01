# terraform-google-apikeys

Terraform module for creating and managing Google Cloud API Keys with optional Secret Manager integration.

## Requirements

| Name | Version |
|------|---------|
| terraform | `>= 1.3` |
| google | `>= 7.0` |

> **Note:** Requires authentication via Service Account Impersonation — `apikeys.googleapis.com` does not support Cloud SDK or Cloud Shell credentials.

## Usage

### Basic

```hcl
module "api_key" {
  source = "github.com/ssro/terraform-google-apikeys?ref=v0.0.5"

  project     = "my-gcp-project"
  name_prefix = "my-app"
}
```

### With restrictions

```hcl
module "api_key" {
  source = "github.com/ssro/terraform-google-apikeys?ref=v0.0.5"

  project      = "my-gcp-project"
  name_prefix  = "my-app"
  display_name = "My App Key"

  browser_key_restrictions = {
    allowed_referrers = ["https://example.com/*"]
  }

  api_targets = [
    {
      service = "translate.googleapis.com"
      methods = ["GET*"]
    }
  ]
}
```

### With Secret Manager

```hcl
module "api_key" {
  source = "github.com/ssro/terraform-google-apikeys?ref=v0.0.5"

  project     = "my-gcp-project"
  name_prefix = "my-app"

  enable_secret_manager            = true
  secret_manager_replica_locations = ["us-central1", "us-east1"]
  secret_manager_labels            = {
    environment = "production"
  }
}
```

### Key rotation

Changing `name_suffix` creates a new key before destroying the old one, enabling zero-downtime rotation.

```hcl
module "api_key" {
  source = "github.com/ssro/terraform-google-apikeys?ref=v0.0.5"

  project     = "my-gcp-project"
  name_prefix = "my-app"
  name_suffix = "v2" # was "v1"
}
```

### Service account bound key

```hcl
module "api_key" {
  source = "github.com/ssro/terraform-google-apikeys?ref=v0.0.5"

  project               = "my-gcp-project"
  name_prefix           = "my-app"
  service_account_email = "my-sa@my-gcp-project.iam.gserviceaccount.com"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `project` | GCP project ID | `string` | — | yes |
| `name_prefix` | Prefix for the key resource name | `string` | — | yes |
| `name_suffix` | Version suffix for rotation (e.g. `v1`). Changing triggers replacement | `string` | `null` | no |
| `display_name` | Human-readable name shown in Cloud Console | `string` | `null` | no |
| `labels` | Labels to apply to the key resource | `map(string)` | `{}` | no |
| `service_account_email` | Bind the key to a service account for auth-enabled usage | `string` | `null` | no |
| `enable_apis` | Auto-enable `apikeys.googleapis.com` (and Secret Manager if needed) | `bool` | `true` | no |
| `disable_services_on_destroy` | Disable APIs when the module is destroyed | `bool` | `false` | no |
| `browser_key_restrictions` | HTTP referrers allowed to use the key | `object({ allowed_referrers = list(string) })` | `null` | no |
| `server_key_restrictions` | IPs/CIDRs allowed to use the key | `object({ allowed_ips = list(string) })` | `null` | no |
| `android_key_restrictions` | Android apps allowed to use the key | `list(object({ package_name, sha1_fingerprint }))` | `[]` | no |
| `ios_key_restrictions` | iOS bundle IDs allowed to use the key | `object({ allowed_bundle_ids = list(string) })` | `null` | no |
| `api_targets` | APIs and methods the key is scoped to | `list(object({ service, methods? }))` | `[]` | no |
| `enable_secret_manager` | Store the key string in Secret Manager | `bool` | `false` | no |
| `secret_manager_secret_id` | Secret ID override. Defaults to the constructed key name | `string` | `null` | no |
| `secret_manager_replica_locations` | Regions to replicate the secret to | `list(string)` | `["us-central1"]` | no |
| `secret_manager_labels` | Labels to apply to the Secret Manager secret | `map(string)` | `{}` | no |
| `timeout_create` | Create timeout | `string` | `"20m"` | no |
| `timeout_update` | Update timeout | `string` | `"20m"` | no |
| `timeout_delete` | Delete timeout | `string` | `"20m"` | no |

Only one of `browser_key_restrictions`, `server_key_restrictions`, `android_key_restrictions`, or `ios_key_restrictions` may be set at a time. A `precondition` will catch this at plan time.

## Outputs

| Name | Description |
|------|-------------|
| `key_id` | Full resource ID (`projects/.../locations/global/keys/...`) |
| `key_string` | Raw API key value — **sensitive** |
| `key_uid` | UUID4 unique identifier |
| `key_name` | Constructed key name (`name_prefix[-name_suffix]`) |
| `display_name` | Display name of the key |
| `secret_manager_secret_id` | Secret ID (if `enable_secret_manager = true`) |
| `secret_manager_secret_name` | Full secret name (if `enable_secret_manager = true`) |
| `secret_manager_version_name` | Full secret version name (if `enable_secret_manager = true`) |

## License

Apache 2.0
