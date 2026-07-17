#!/usr/bin/env bash
# Purpose: controlled BigQuery recovery starter using table snapshots or a replicated dataset.
# Prerequisites: bq CLI, authenticated recovery identity, approved incident and tested target datasets.
set -euo pipefail

: "${INCIDENT_ID:?INCIDENT_ID required}"
: "${PROJECT_ID:?PROJECT_ID required}"
: "${PRIMARY_DATASET:?PRIMARY_DATASET required}"
: "${RECOVERY_DATASET:?RECOVERY_DATASET required}"
: "${LOCATION:?LOCATION required}"
: "${RECOVERY_TIMESTAMP:?RECOVERY_TIMESTAMP required, e.g. 2026-07-12T04:00:00Z}"

log() { printf '%s incident=%s %s\n' "$(date -u +%FT%TZ)" "$INCIDENT_ID" "$*"; }

log "Validating datasets"
bq --location="$LOCATION" show --dataset "${PROJECT_ID}:${PRIMARY_DATASET}" >/dev/null
bq --location="$LOCATION" show --dataset "${PROJECT_ID}:${RECOVERY_DATASET}" >/dev/null

# Example critical table list is read from a governed file, not hard-coded in production.
while IFS=, read -r table_name expected_min_rows; do
  [[ "$table_name" == "table_name" ]] && continue
  log "Creating recovery snapshot for ${table_name}"
  bq --location="$LOCATION" cp --snapshot \
    "${PROJECT_ID}:${PRIMARY_DATASET}.${table_name}@${RECOVERY_TIMESTAMP}" \
    "${PROJECT_ID}:${RECOVERY_DATASET}.${table_name}_${INCIDENT_ID}"

  actual=$(bq --location="$LOCATION" query --use_legacy_sql=false --format=csv \
    "SELECT COUNT(*) FROM \`${PROJECT_ID}.${RECOVERY_DATASET}.${table_name}_${INCIDENT_ID}\`" | tail -1)
  if (( actual < expected_min_rows )); then
    log "ERROR row-count validation failed table=${table_name} actual=${actual} expected_min=${expected_min_rows}"
    exit 2
  fi
  log "Validated table=${table_name} rows=${actual}"
done < critical_tables.csv

log "Recovery data prepared. Consumer cutover requires separate approval gate."
