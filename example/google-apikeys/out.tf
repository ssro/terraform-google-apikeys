output "key_id" {
  value = module.api_key.key_id
}
output "key_string" {
  value     = module.api_key.key_string
  sensitive = true
}
output "key_uid" {
  value = module.api_key.key_uid
}
output "display_name" {
  value = module.api_key.display_name
}
