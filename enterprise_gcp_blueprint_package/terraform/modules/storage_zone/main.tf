resource "google_storage_bucket" "zone" {
  name                        = var.bucket_name
  project                     = var.project_id
  location                    = var.location
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  force_destroy               = false
  labels                      = var.labels
  versioning { enabled = var.enable_versioning }
  lifecycle_rule {
    condition { age = var.archive_after_days }
    action { type = "SetStorageClass" storage_class = "ARCHIVE" }
  }
  encryption { default_kms_key_name = var.kms_key_name }
}
