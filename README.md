# Google API Keys Terraform Module

This Terraform module creates and manages Google Cloud API Keys with comprehensive restriction support and optional Secret Manager integration. It provides a flexible way to create API keys with various platform restrictions (Android, iOS, Browser, Server) and API service targeting, while securely storing the keys in Google Secret Manager.

## Features

- ✅ Support for all API key restriction types (Android, iOS, Browser/HTTP referrer, Server/IP)
- ✅ API service and method targeting
- ✅ Service account binding for enhanced security
- ✅ Automatic API enablement with configurable options
- ✅ Comprehensive input validation
- ✅ Configurable timeouts
- ✅ Sensitive output handling
- ✅ Optional Secret Manager integration for secure key storage

## Usage

### Basic Usage

```hcl
module "api_key" {
  source = "git::https://github.com/your-org/terraform-google-apikeys.git"

  name         = "my-api-key"
  display_name = "My Application API Key"
  project_id   = "my-gcp-project"
}
```

### Comprehensive Example with Secret Manager

```hcl
module "comprehensive_api_key" {
  source = "git::https://github.com/your-org/terraform-google-apikeys.git"

  name         = "comprehensive-api-key"
  display_name = "Comprehensive API Key Example"
  project_id   = "my-gcp-project"
  

  # Store API key in Secret Manager
  secret_manager_config = {
    secret_id         = "my-api-key-secret"
    replica_locations = ["us-central1", "us-east1"]
    labels = {
      environment = "production"
      team        = "backend"
    }
  }

  restrictions = {
    # Android app restrictions
    android_key_restrictions = {
      allowed_applications = [
        {
          package_name      = "com.example.myapp"
          sha1_fingerprint = "1699466a142d4c558901ed370f5edaced5c947b4"
        }
      ]
    }

    # iOS app restrictions
    ios_key_restrictions = {
      allowed_bundle_ids = ["com.example.myiosapp"]
    }

    # Browser restrictions
    browser_key_restrictions = {
      allowed_referrers = [
        "https://example.com/*",
        "https://*.mydomain.com/*"
      ]
    }

    # Server IP restrictions
    server_key_restrictions = {
      allowed_ips = [
        "192.168.1.0/24",
        "10.0.0.1"
      ]
    }

    # API service restrictions
    api_targets = [
      {
        service = "translate.googleapis.com"
        methods = ["GET*", "POST*"]
      },
      {
        service = "maps.googleapis.com"
        methods = ["*"]
      }
    ]
  }
}
```

### Android Application Key

```hcl
module "android_key" {
  source = "git::https://github.com/your-org/terraform-google-apikeys.git"

  name         = "android-app-key"
  display_name = "Android Application Key"
  project_id   = "my-gcp-project"

  # Store in Secret Manager
  secret_manager_config = {
    secret_id = "android-api-key"
    labels = {
      platform = "android"
      type     = "mobile-app"
    }
  }

  restrictions = {
    android_key_restrictions = {
      allowed_applications = [
        {
          package_name      = "com.mycompany.androidapp"
          sha1_fingerprint = "1699466a142d4c558901ed370f5edaced5c947b4"
        }
      ]
    }
    
    api_targets = [
      {
        service = "maps.googleapis.com"
        methods = ["GET*"]
      }
    ]
  }
}
```

### Web Application Key with Secret Manager

```hcl
module "web_key" {
  source = "git::https://github.com/your-org/terraform-google-apikeys.git"

  name         = "web-app-key"
  display_name = "Web Application Key"
  project_id   = "my-gcp-project"

  # Store in Secret Manager
  secret_manager_config = {
    secret_id = "web-app-api-key"
    labels = {
      environment = "staging"
      type        = "web-app"
    }
  }

  restrictions = {
    browser_key_restrictions = {
      allowed_referrers = [
        "https://mywebapp.com/*",
        "https://*.mywebapp.com/*"
      ]
    }
    
    api_targets = [
      {
        service = "translate.googleapis.com"
        methods = ["GET*"]
      }
    ]
  }
}
```

### Server-to-Server Key

```hcl
module "server_key" {
  source = "git::https://github.com/your-org/terraform-google-apikeys.git"

  name         = "server-key"
  display_name = "Server API Key"
  project_id   = "my-gcp-project"

  # Multi-region Secret Manager storage
  secret_manager_config = {
    secret_id         = "server-api-key"
    replica_locations = ["us-central1", "europe-west1", "asia-east1"]
    labels = {
      environment = "production"
      type        = "server"
      tier        = "critical"
    }
  }

  restrictions = {
    server_key_restrictions = {
      allowed_ips = [
        "192.168.1.100",
        "10.0.0.0/8"
      ]
    }
    
    api_targets = [
      {
        service = "storage.googleapis.com"
      }
    ]
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | \>= 1.0 |
| google | \>= 7.0 |

## Providers

| Name | Version |
|------|---------|
| google | \>= 7.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | The resource name of the key. Must be unique within the project, conform with RFC-1034, and match [a-z]([a-z0-9-]{0,61}[a-z0-9])? | `string` | n/a | yes |
| project_id | The project ID where the API key will be created | `string` | n/a | yes |
| display_name | Human-readable display name of this API key | `string` | `null` | no |
| service_account_email | Email of the service account the key is bound to. If specified, the key is a service account bound key | `string` | `null` | no |
| enable_apis | Whether to enable the API Keys API | `bool` | `true` | no |
| disable_services_on_destroy | Whether to disable the API when the resource is destroyed | `bool` | `false` | no |
| restrictions | Key restrictions configuration | <pre>object({<br>  android_key_restrictions = optional(object({<br>    allowed_applications = list(object({<br>      package_name      = string<br>      sha1_fingerprint = string<br>    }))<br>  }))<br>  <br>  ios_key_restrictions = optional(object({<br>    allowed_bundle_ids = list(string)<br>  }))<br>  <br>  browser_key_restrictions = optional(object({<br>    allowed_referrers = list(string)<br>  }))<br>  <br>  server_key_restrictions = optional(object({<br>    allowed_ips = list(string)<br>  }))<br>  <br>  api_targets = optional(list(object({<br>    service = string<br>    methods = optional(list(string))<br>  })))<br>})</pre> | `null` | no |
| timeout_create | Timeout for create operations | `string` | `"20m"` | no |
| timeout_update | Timeout for update operations | `string` | `"20m"` | no |
| timeout_delete | Timeout for delete operations | `string` | `"20m"` | no |
| secret_manager_config | Configuration for storing the API key in Secret Manager | <pre>object({<br>  secret_id         = string<br>  replica_locations = optional(list(string))<br>  labels           = optional(map(string))<br>})</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | The identifier for the resource with format projects/{{project}}/locations/global/keys/{{name}} |
| key_string | The encrypted and signed value held by this key (sensitive) |
| uid | Unique ID in UUID4 format |
| name | The resource name of the key |
| display_name | Human-readable display name of the API key |
| project | The project ID where the API key was created |
| secret_manager_secret_id | The ID of the Secret Manager secret (if created) |
| secret_manager_secret_name | The full name of the Secret Manager secret (if created) |
| secret_manager_version_name | The full name of the Secret Manager secret version (if created) |

## Important Notes

### Security Best Practices

1. **Always apply restrictions**: Unrestricted API keys pose security risks. Use appropriate restrictions based on your use case.

2. **Handle key_string carefully**: The `key_string` output is marked as sensitive. Store it securely and avoid logging it.

3. **Service account binding**: For enhanced security, consider binding the key to a service account with minimal required permissions.

4. **Regular key rotation**: Implement a key rotation strategy for production environments.

### Secret Manager Integration

The module optionally integrates with Google Cloud Secret Manager to securely store API keys:

- **Automatic secret creation**: Creates a Secret Manager secret when `secret_manager_config` is provided
- **Multi-region replication**: Configure replica locations for high availability
- **Labeling support**: Add custom labels for organization and management
- **Automatic API enablement**: Enables Secret Manager API when needed

To use Secret Manager integration:

```hcl
secret_manager_config = {
  secret_id         = "my-api-key-secret"      # Required: Secret ID
  replica_locations = ["us-central1", "us-east1"]  # Optional: Defaults to ["us-central1"]
  labels = {                                   # Optional: Custom labels
    environment = "production"
    team        = "backend"
  }
}
```

### Authentication Requirements

The Terraform configuration for the API Keys must be deployed while authenticating to Google APIs using Service Account Impersonation. The API for apikeys.googleapis.com does not permit access using Cloud Identities generated by Cloud SDK or Cloud Shell.

### Restriction Types

- **Android Key Restrictions**: Limit usage to specific Android applications by package name and SHA1 fingerprint
- **iOS Key Restrictions**: Limit usage to specific iOS applications by bundle ID
- **Browser Key Restrictions**: Limit usage to specific HTTP referrers (websites)
- **Server Key Restrictions**: Limit usage to specific IP addresses or CIDR blocks
- **API Targets**: Limit which Google APIs and methods can be accessed

### SHA1 Fingerprint Format

The module accepts SHA1 fingerprints in both formats:
- With colons: `DA:39:A3:EE:5E:6B:4B:0D:32:55:BF:EF:95:60:18:90:AF:D8:07:09`
- Without colons: `DA39A3EE5E6B4B0D3255BFEF95601890AFD80709`

The output format will be without colons.

### API Methods

When specifying API methods, you can use:
- Specific methods: `google.cloud.translate.v2.TranslateService.GetSupportedLanguage`
- Wildcards: `Get*`, `translate.googleapis.com.Get*`
- All methods: `*` or leave methods empty

### Accessing Stored API Keys

To retrieve API keys from Secret Manager in your applications or other Terraform configurations:

#### Using gcloud CLI:
```bash
# Get the latest version
gcloud secrets versions access latest --secret="my-api-key-secret" --project="my-gcp-project"

# Get a specific version
gcloud secrets versions access 1 --secret="my-api-key-secret" --project="my-gcp-project"
```

#### Using Terraform data source:
```hcl
data "google_secret_manager_secret_version" "api_key" {
  secret  = "projects/my-gcp-project/secrets/my-api-key-secret"
  version = "latest"
}

# Use the API key (marked as sensitive)
locals {
  api_key = data.google_secret_manager_secret_version.api_key.secret_data
}
```

#### Using application code:
```python
from google.cloud import secretmanager

client = secretmanager.SecretManagerServiceClient()
name = f"projects/my-gcp-project/secrets/my-api-key-secret/versions/latest"
response = client.access_secret_version(request={"name": name})
api_key = response.payload.data.decode("UTF-8")
```

## Examples

Complete examples are available in the `examples/` directory:

- **comprehensive**: Shows all features including Secret Manager integration
- See `examples/comprehensive/main.tf` for detailed usage patterns

## IAM Permissions

To use this module, the Terraform service account needs the following IAM roles:

### For API Key creation:
- `roles/serviceusage.serviceUsageAdmin` (to enable APIs)
- `roles/apikeys.admin` (to manage API keys)

### For Secret Manager integration (if used):
- `roles/secretmanager.admin` (to create and manage secrets)

### Example IAM binding:
```hcl
resource "google_project_iam_member" "terraform_apikeys" {
  project = var.project_id
  role    = "roles/apikeys.admin"
  member  = "serviceAccount:terraform@my-project.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "terraform_secretmanager" {
  count   = var.use_secret_manager ? 1 : 0
  project = var.project_id
  role    = "roles/secretmanager.admin"
  member  = "serviceAccount:terraform@my-project.iam.gserviceaccount.com"
}
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This module is released under the Apache 2.0 License. See LICENSE file for details.
