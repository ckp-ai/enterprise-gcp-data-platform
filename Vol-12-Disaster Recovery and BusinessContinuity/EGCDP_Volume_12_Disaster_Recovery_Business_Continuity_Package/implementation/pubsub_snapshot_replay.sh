#!/usr/bin/env bash
# Purpose: snapshot and replay a Pub/Sub subscription for controlled pipeline recovery.
set -euo pipefail
: "${PROJECT_ID:?}"; : "${SUBSCRIPTION:?}"; : "${SNAPSHOT:?}"; : "${INCIDENT_ID:?}"

log(){ printf '%s incident=%s %s\n' "$(date -u +%FT%TZ)" "$INCIDENT_ID" "$*"; }

gcloud pubsub subscriptions describe "$SUBSCRIPTION" --project "$PROJECT_ID" >/dev/null
if ! gcloud pubsub snapshots describe "$SNAPSHOT" --project "$PROJECT_ID" >/dev/null 2>&1; then
  log "Creating snapshot ${SNAPSHOT}"
  gcloud pubsub snapshots create "$SNAPSHOT" --subscription "$SUBSCRIPTION" --project "$PROJECT_ID"
fi

log "Seeking subscription to snapshot. Confirm consumers are fenced before this step."
gcloud pubsub subscriptions seek "$SUBSCRIPTION" --snapshot "$SNAPSHOT" --project "$PROJECT_ID"
log "Seek submitted. Monitor backlog, duplicates, processing errors and business reconciliation."
