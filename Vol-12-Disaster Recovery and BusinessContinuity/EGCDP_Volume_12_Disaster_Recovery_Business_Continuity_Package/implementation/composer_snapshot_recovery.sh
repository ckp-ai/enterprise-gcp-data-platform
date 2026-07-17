#!/usr/bin/env bash
# Purpose: save or load a Managed Airflow / Cloud Composer environment snapshot.
set -euo pipefail
ACTION=${1:?save|load}
: "${PROJECT_ID:?}"; : "${ENVIRONMENT:?}"; : "${LOCATION:?}"; : "${SNAPSHOT_LOCATION:?}"

case "$ACTION" in
  save)
    gcloud composer environments snapshots save "$ENVIRONMENT" \
      --project "$PROJECT_ID" --location "$LOCATION" \
      --snapshot-location "$SNAPSHOT_LOCATION"
    ;;
  load)
    : "${SNAPSHOT_PATH:?exact snapshot path required for load}"
    gcloud composer environments snapshots load "$ENVIRONMENT" \
      --project "$PROJECT_ID" --location "$LOCATION" \
      --snapshot-path "$SNAPSHOT_PATH"
    ;;
  *) echo "Unsupported action" >&2; exit 64;;
esac
# Pause DAGs and control scheduling during migration/recovery to avoid duplicate runs.
# Snapshot locations contain sensitive Airflow database content and fernet material.
