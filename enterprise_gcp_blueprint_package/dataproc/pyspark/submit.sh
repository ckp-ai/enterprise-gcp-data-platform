#!/usr/bin/env bash
set -euo pipefail
gcloud dataproc batches submit pyspark customer_silver_transform.py   --region=us-central1   --project=gcp-edp-cust-prod-001   --subnet=projects/gcp-net-prod-001/regions/us-central1/subnetworks/snet-data-prod   --service-account=sa-dataproc-customer-prod@gcp-edp-cust-prod-001.iam.gserviceaccount.com
