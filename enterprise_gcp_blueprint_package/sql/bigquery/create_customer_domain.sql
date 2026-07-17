CREATE SCHEMA IF NOT EXISTS `gcp-edp-cust-prod-001.customer_raw`
OPTIONS(location="US", description="Immutable raw customer domain data");

CREATE TABLE IF NOT EXISTS `gcp-edp-cust-prod-001.customer_raw.events` (
  event_id STRING NOT NULL,
  customer_id STRING,
  event_ts TIMESTAMP,
  event_type STRING,
  payload JSON,
  ingestion_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
)
PARTITION BY DATE(event_ts)
CLUSTER BY customer_id, event_type;

CREATE OR REPLACE ROW ACCESS POLICY customer_country_policy
ON `gcp-edp-cust-prod-001.customer_raw.events`
GRANT TO ("group:customer-analysts@example.com")
FILTER USING (JSON_VALUE(payload, "$.country") IN ("US", "CA"));
