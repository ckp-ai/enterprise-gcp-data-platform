# Purpose: hardened Terraform state bucket. Apply in a dedicated bootstrap project.
variable "project_id" { type = string }
variable "bucket_name" { type = string }
variable "region" { type = string }
variable "kms_key_name" { type = string }

resource "google_storage_bucket" "tfstate" {
  project                     = var.project_id
  name                        = var.bucket_name
  location                    = var.region
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  force_destroy               = false
  versioning { enabled = true }
  soft_delete_policy { retention_duration_seconds = 2592000 }
  retention_policy { retention_period = 7776000 }
  encryption { default_kms_key_name = var.kms_key_name }
  labels = { purpose = "terraform-state", criticality = "tier0" }
}

# Grant only CI/CD state identities and audited break-glass recovery group.
resource "google_storage_bucket_iam_member" "state_ci" {
  bucket = google_storage_bucket.tfstate.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:terraform-deployer@${var.project_id}.iam.gserviceaccount.com"
}
