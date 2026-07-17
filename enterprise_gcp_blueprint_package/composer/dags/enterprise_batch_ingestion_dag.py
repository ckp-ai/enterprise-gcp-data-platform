from __future__ import annotations
import pendulum
from airflow import DAG
from airflow.providers.google.cloud.operators.dataflow import DataflowStartFlexTemplateOperator
from airflow.providers.google.cloud.operators.bigquery import BigQueryInsertJobOperator

PROJECT_ID = "gcp-edp-cust-prod-001"
REGION = "us-central1"

with DAG(
    dag_id="enterprise_batch_ingestion",
    start_date=pendulum.datetime(2026, 1, 1, tz="UTC"),
    schedule="0 * * * *",
    catchup=False,
    default_args={"retries": 2},
    tags=["enterprise", "batch", "data-platform"],
) as dag:
    ingest = DataflowStartFlexTemplateOperator(
        task_id="ingest_to_raw",
        project_id=PROJECT_ID,
        location=REGION,
        body={
            "launchParameter": {
                "jobName": "batch-file-ingest-{{ ds_nodash }}-{{ ts_nodash }}",
                "containerSpecGcsPath": "gs://edp-templates/dataflow/batch_ingest.json",
                "parameters": {
                    "input": "gs://edp-landing/customer/{{ ds }}/*.json",
                    "output": "gcp-edp-cust-prod-001:customer_raw.events",
                    "deadLetter": "gs://edp-quarantine/customer/events/{{ ds }}/",
                },
            }
        },
    )
    validate = BigQueryInsertJobOperator(
        task_id="validate_row_counts",
        configuration={"query": {"query": "SELECT COUNT(*) AS rows_loaded FROM `gcp-edp-cust-prod-001.customer_raw.events` WHERE DATE(_PARTITIONTIME)=CURRENT_DATE()", "useLegacySql": False}},
    )
    ingest >> validate
