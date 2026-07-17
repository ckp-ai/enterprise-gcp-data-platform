# Purpose: Example Analytics Hub listing structure for a certified data product.
# Replace placeholder IDs with approved project, exchange, listing, and dataset values.
resource "google_bigquery_analytics_hub_data_exchange" "domain_exchange" {
  project          = var.marketplace_project_id
  location         = var.region
  data_exchange_id = "enterprise_data_products"
  display_name     = "Enterprise Data Products"
  description      = "Curated and certified data products published by enterprise domains."
}

resource "google_bigquery_analytics_hub_listing" "customer_360" {
  project          = var.marketplace_project_id
  location         = var.region
  data_exchange_id = google_bigquery_analytics_hub_data_exchange.domain_exchange.data_exchange_id
  listing_id       = "customer_360_gold"
  display_name     = "Customer 360 Gold"
  description      = "Certified customer profile data product with governed access."
  bigquery_dataset {
    dataset = "projects/${var.producer_project_id}/datasets/customer_products"
  }
}
