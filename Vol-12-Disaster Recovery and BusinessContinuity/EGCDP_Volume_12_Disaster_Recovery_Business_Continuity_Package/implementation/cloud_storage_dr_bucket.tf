# Purpose: protected dual-region recovery bucket for critical objects.
# Validate region pair, residency, feature support, quotas and organization policies before use.
variable "project_id" { type = string }
variable "bucket_name" { type = string }
variable "dual_region" { type = string }
variable "kms_key_name" { type = string }

resource "google_storage_bucket" "dr" {
  project                     = var.project_id
  name                        = var.bucket_name
  location                    = var.dual_region
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  force_destroy               = false

  rpo = "ASYNC_TURBO"

  versioning { enabled = true }

  soft_delete_policy {
    retention_duration_seconds = 1209600 # 14 days; replace with approved class policy.
  }

  retention_policy {
    retention_period = 2592000 # 30 days; do not lock until governance approval.
  }

  encryption { default_kms_key_name = var.kms_key_name }

  lifecycle_rule {
    condition { age = 90; with_state = "ARCHIVED" }
    action { type = "SetStorageClass"; storage_class = "COLDLINE" }
  }

  labels = {
    environment = "prod"
    service_tier = "tier1"
    dr_role = "recovery"
    data_class = "restricted"
  }
}
