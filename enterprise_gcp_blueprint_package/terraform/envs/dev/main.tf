module "project_customer_dev" {
  source       = "../../modules/project_factory"
  project_name = "Customer Domain Dev"
  project_id   = "gcp-edp-cust-dev-001"
  folder_id    = var.dev_folder_id
  labels       = { environment="dev", business_domain="customer", managed_by="terraform" }
  enabled_apis = ["bigquery.googleapis.com", "storage.googleapis.com", "pubsub.googleapis.com", "dataflow.googleapis.com"]
}
