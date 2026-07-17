resource "google_bigquery_dataset" "dataset" {
  dataset_id                 = var.dataset_id
  project                    = var.project_id
  location                   = var.location
  description                = var.description
  delete_contents_on_destroy = false
  labels                     = var.labels
  default_table_expiration_ms = var.default_table_expiration_ms
  access {
    role          = "OWNER"
    group_by_email = var.owner_group
  }
}
resource "google_bigquery_table" "tables" {
  for_each   = var.tables
  project    = var.project_id
  dataset_id = google_bigquery_dataset.dataset.dataset_id
  table_id   = each.key
  schema     = jsonencode(each.value.schema)
  deletion_protection = true
  labels = merge(var.labels, { table = each.key })
}
