# Example showing all possible configurations for the Google API Keys module

# Provider configuration
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 7.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# Create a service account for demonstration
resource "google_service_account" "api_key_sa" {
  account_id   = "api-key-service-account"
  display_name = "API Key Service Account"
  description  = "Service account for API key binding example"
}

# Comprehensive example with all restriction types and Secret Manager integration
module "comprehensive_api_key" {
  source = "../../" # Path to the root module

  name         = "comprehensive-api-key"
  display_name = "Comprehensive API Key Example"
  project_id   = var.project_id

  # Optional service account binding
  service_account_email = google_service_account.api_key_sa.email

  # Enable APIs (recommended for new projects)
  enable_apis                   = true
  disable_services_on_destroy   = false

  # Store API key in Secret Manager
  secret_manager_config = {
    secret_id         = "comprehensive-api-key-secret"
    replica_locations = ["us-central1", "us-east1"]
    labels = {
      environment = "production"
      team        = "backend"
      purpose     = "api-access"
    }
  }

  # Comprehensive restrictions covering all use cases
  restrictions = {
    # Android application restrictions
    android_key_restrictions = {
      allowed_applications = [
        {
          package_name      = "com.example.myapp"
          sha1_fingerprint = "1699466a142d4c558901ed370f5edaced5c947b4"
        },
        {
          package_name      = "com.example.anotherapp"
          sha1_fingerprint = "DA39A3EE5E6B4B0D3255BFEF95601890AFD80709"
        }
      ]
    }

    # iOS application restrictions
    ios_key_restrictions = {
      allowed_bundle_ids = [
        "com.google.app1",
        "com.example.myiosapp"
      ]
    }

    # Browser/HTTP referrer restrictions
    browser_key_restrictions = {
      allowed_referrers = [
        "https://example.com/*",
        "https://*.mydomain.com/*",
        "http://localhost:3000/*"
      ]
    }

    # Server IP restrictions
    server_key_restrictions = {
      allowed_ips = [
        "192.168.1.0/24",
        "10.0.0.1",
        "127.0.0.1"
      ]
    }

    # API service and method restrictions
    api_targets = [
      {
        service = "translate.googleapis.com"
        methods = ["GET*", "POST*"]
      },
      {
        service = "maps.googleapis.com"
        methods = ["*"] # Allow all methods
      },
      {
        service = "youtube.googleapis.com"
        # No methods specified means all methods allowed
      }
    ]
  }

  # Custom timeouts
  timeout_create = "30m"
  timeout_update = "30m"
  timeout_delete = "30m"
}

# Minimal API key (no restrictions)
module "minimal_api_key" {
  source = "../../"

  name         = "minimal-key"
  display_name = "Minimal API Key"
  project_id   = var.project_id
}

# Android-only API key with Secret Manager
module "android_only_key" {
  source = "../../"

  name         = "android-key"
  display_name = "Android Only API Key"
  project_id   = var.project_id

  # Store in Secret Manager with minimal configuration
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

# Web application API key with Secret Manager
module "web_app_key" {
  source = "../../"

  name         = "web-app-key"
  display_name = "Web Application API Key"
  project_id   = var.project_id

  # Store in Secret Manager with minimal configuration
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

# Server-to-server API key with multi-region Secret Manager
module "server_key" {
  source = "../../"

  name         = "server-key"
  display_name = "Server API Key"
  project_id   = var.project_id

  # Store in Secret Manager with multi-region replication
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

# iOS-only API key
module "ios_key" {
  source = "../../"

  name         = "ios-key"
  display_name = "iOS Application Key"
  project_id   = var.project_id

  secret_manager_config = {
    secret_id = "ios-api-key"
    labels = {
      platform = "ios"
      type     = "mobile-app"
    }
  }

  restrictions = {
    ios_key_restrictions = {
      allowed_bundle_ids = [
        "com.mycompany.iosapp",
        "com.mycompany.iosapp.dev"
      ]
    }

    api_targets = [
      {
        service = "firebase.googleapis.com"
        methods = ["GET*", "POST*"]
      }
    ]
  }
}