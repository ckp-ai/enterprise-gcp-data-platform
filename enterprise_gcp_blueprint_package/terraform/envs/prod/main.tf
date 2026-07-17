module "project_customer_prod" {
  source       = "../../modules/project_factory"
  project_name = "Customer Domain Prod"
  project_id   = "gcp-edp-cust-prod-001"
  folder_id    = var.prod_folder_id
  labels       = { environment="prod", business_domain="customer", managed_by="terraform", criticality="tier1" }
  enabled_apis = ["bigquery.googleapis.com", "storage.googleapis.com", "pubsub.googleapis.com", "dataflow.googleapis.com", "cloudkms.googleapis.com"]
}
