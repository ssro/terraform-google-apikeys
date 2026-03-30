module "api_key" {
  source = "github.com/ssro/terraform-google-apikeys?ref=v0.0.2"

  name_prefix             = var.name_prefix
  name_suffix             = var.name_suffix
  project                 = var.project
  display_name            = var.display_name
  enable_secret_manager   = var.enable_secret_manager
  server_key_restrictions = var.server_key_restrictions
  api_targets             = var.api_targets
}
