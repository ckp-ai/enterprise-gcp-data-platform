-- Purpose: Example BigQuery data product table with partitioning, clustering and governance hooks.
CREATE SCHEMA IF NOT EXISTS `prj-customer-prod.customer_products`
OPTIONS(location = 'US', description = 'Certified customer domain data products');

CREATE TABLE IF NOT EXISTS `prj-customer-prod.customer_products.customer_360_v1` (
  customer_id STRING NOT NULL OPTIONS(description='Stable enterprise customer identifier'),
  household_id STRING OPTIONS(description='Enterprise household identifier'),
  region_code STRING OPTIONS(description='Residency and servicing region'),
  lifecycle_status STRING OPTIONS(description='Active, inactive, prospect, former'),
  primary_segment STRING OPTIONS(description='Approved marketing or service segment'),
  consent_marketing BOOL OPTIONS(description='Marketing consent indicator'),
  profile_effective_ts TIMESTAMP NOT NULL OPTIONS(description='Product record effective timestamp'),
  data_quality_score NUMERIC OPTIONS(description='Composite quality score from certified rules'),
  record_created_ts TIMESTAMP NOT NULL OPTIONS(description='Record creation timestamp')
)
PARTITION BY DATE(profile_effective_ts)
CLUSTER BY region_code, lifecycle_status, primary_segment
OPTIONS(
  description='Customer 360 certified data product. Access through authorized views and Analytics Hub listings.',
  labels=[('business_domain','customer'),('data_product','customer_360'),('classification','confidential')]
);
