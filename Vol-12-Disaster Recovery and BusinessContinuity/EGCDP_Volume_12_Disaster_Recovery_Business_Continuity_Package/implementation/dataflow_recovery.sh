#!/usr/bin/env bash
# Purpose: start a tested Dataflow Flex Template in the recovery region.
set -euo pipefail
: "${PROJECT_ID:?}"; : "${REGION:?}"; : "${TEMPLATE_SPEC_GCS_PATH:?}"; : "${JOB_NAME:?}"
: "${SERVICE_ACCOUNT_EMAIL:?}"; : "${SUBNETWORK:?}"; : "${TEMP_LOCATION:?}"; : "${STAGING_LOCATION:?}"
: "${INPUT_SUBSCRIPTION:?}"; : "${OUTPUT_TABLE:?}"; : "${INCIDENT_ID:?}"

params="inputSubscription=${INPUT_SUBSCRIPTION},outputTable=${OUTPUT_TABLE},incidentId=${INCIDENT_ID}"

gcloud dataflow flex-template run "$JOB_NAME" \
  --project "$PROJECT_ID" \
  --region "$REGION" \
  --template-file-gcs-location "$TEMPLATE_SPEC_GCS_PATH" \
  --service-account-email "$SERVICE_ACCOUNT_EMAIL" \
  --subnetwork "$SUBNETWORK" \
  --temp-location "$TEMP_LOCATION" \
  --staging-location "$STAGING_LOCATION" \
  --parameters "$params" \
  --disable-public-ips

# Deployment success is not recovery success. Validate backlog, duplicate rate,
# watermark, output reconciliation, KMS access and SLO before traffic release.
