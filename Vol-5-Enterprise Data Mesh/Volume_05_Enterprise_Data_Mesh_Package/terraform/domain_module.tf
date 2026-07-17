# Purpose: Reusable domain foundation module for a Google Cloud data mesh.
# Production note: validate organization policies, VPC SC, regions, and IAM bindings before use.
variable "domain" { type = string }
variable "environment" { type = string }
variable "billing_account" { type = string }
variable "folder_id" { type = string }
variable "region" { type = string }
variable "project_prefix" { type = string }

resource "google_project" "domain" {
  name            = "${var.project_prefix}-${var.domain}-${var.environment}"
  project_id      = "${var.project_prefix}-${var.domain}-${var.environment}"
  folder_id       = var.folder_id
  billing_account = var.billing_account
  labels = {
    business_domain = var.domain
    environment     = var.environment
    managed_by      = "terraform"
    architecture    = "data-mesh"
  }
}

resource "google_project_service" "apis" {
  for_each = toset([
    "bigquery.googleapis.com",
    "storage.googleapis.com",
    "dataplex.googleapis.com",
    "datacatalog.googleapis.com",
    "analyticshub.googleapis.com",
    "cloudkms.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com"
  ])
  project = google_project.domain.project_id
  service = each.value
}

resource "google_bigquery_dataset" "product" {
  project     = google_project.domain.project_id
  dataset_id  = "${replace(var.domain, "-", "_")}_products"
  location    = var.region
  description = "Certified data products for ${var.domain}."
  labels = {
    business_domain = var.domain
    environment     = var.environment
    data_layer      = "product"
  }
}
