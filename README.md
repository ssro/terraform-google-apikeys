# terraform-google-apikeys

Terraform module for creating and managing Google Cloud API Keys with optional Secret Manager integration.

## Requirements

| Name | Version |
|------|---------|
| terraform | `>= 1.0` |
| google | `>= 7.0` |

> **Note:** Requires authentication via Service Account Impersonation — `apikeys.googleapis.com` does not support Cloud SDK or Cloud Shell credentials.

## Usage

### Basic

```hcl
module "api_key" {
  source = "github.com/ssro/terraform-google-apikeys?ref=v0.0.3"

  project     = "my-gcp-project"
  name_prefix = "my-app"
}
```

### With server IP restrictions and API targeting

```hcl
module "api_key" {
  source = "github.com/ssro/terraform-google-apikeys?ref=v0.0.3"

  project      = "my-gcp-project"
  name_prefix  = "my-app"
  name_suffix  = "v1"
  display_name = "My App API Key"

  server_key_restrictions = {
    allowed_ips = ["192.168.1.0/24"]
  }

  api_targets = [
    {
      service = "translate.googleapis.com"
      methods = ["GET*"]
    }
  ]
}
```

### With Secret Manager storage

```hcl
module "api_key" {
  source = "github.com/ssro/terraform-google-apikeys?ref=v0.0.3"

  project               = "my-gcp-project"
  name_prefix           = "my-app"
  enable_secret_manager = true

  browser_key_restrictions = {
    allowed_referrers = ["https://example.com/*"]
  }
}
```

### Key rotation

Change `name_suffix` to trigger a safe replacement without changing the key name prefix:

```hcl
module "api_key" {
  source = "github.com/ssro/terraform-google-apikeys?ref=v0.0.3"

  project     = "my-gcp-project"
  name_prefix = "my-app"
  name_suffix = "v2"  # was "v1"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `project` | GCP project ID | `string` | — | yes |
| `name_prefix` | Prefix for the API key resource name | `string` | — | yes |
| `name_suffix` | Version suffix (e.g. `v1`). Changing this triggers key rotation | `string` | `null` | no |
| `display_name` | Human-readable name shown in Cloud Console | `string` | `null` | no |
| `browser_key_restrictions` | HTTP referrers allowed to use the key | `object({ allowed_referrers = list(string) })` | `null` | no |
| `server_key_restrictions` | IPs/CIDRs allowed to use the key | `object({ allowed_ips = list(string) })` | `null` | no |
| `android_key_restrictions` | Android apps allowed to use the key | `list(object({ package_name, sha1_fingerprint }))` | `[]` | no |
| `ios_key_restrictions` | iOS bundle IDs allowed to use the key | `object({ allowed_bundle_ids = list(string) })` | `null` | no |
| `api_targets` | GCP APIs and methods the key is scoped to | `list(object({ service, methods? }))` | `[]` | no |
| `enable_secret_manager` | Store the key string in Secret Manager | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| `key_id` | Full resource ID of the API key |
| `key_string` | Raw API key value — **sensitive** |
| `key_uid` | UUID4 unique identifier |
| `display_name` | Display name of the key |

## License

Apache 2.0
