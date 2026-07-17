terraform {
  required_version = ">= 1.6.0"
  required_providers { google = { source = "hashicorp/google", version = ">= 5.0" } }
}
resource "google_project" "project" {
  name       = var.project_name
  project_id = var.project_id
  folder_id  = var.folder_id
  labels     = var.labels
}
resource "google_project_service" "apis" {
  for_each = toset(var.enabled_apis)
  project  = google_project.project.project_id
  service  = each.key
  disable_on_destroy = false
}
resource "google_project_iam_member" "baseline" {
  for_each = var.iam_members
  project  = google_project.project.project_id
  role     = each.value.role
  member   = each.value.member
}
