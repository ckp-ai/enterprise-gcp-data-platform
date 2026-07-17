# Volume 03 — Enterprise Data Platform

This package contains the detailed Enterprise Google Cloud Data Platform reference architecture for a Fortune 100-scale implementation baseline.

## Primary deliverables

- `docs/Volume_03_Enterprise_Data_Platform_Detailed.docx` — editable architecture volume.
- `pdf/Volume_03_Enterprise_Data_Platform_Detailed.pdf` — polished 72-page PDF.
- `docs/Volume_03_Enterprise_Data_Platform_Source.md` — source manuscript.

## Architecture scope

The volume covers objectives, capabilities, source architecture, batch/streaming/CDC/API/SaaS/file/mainframe/IoT/cross-cloud/partner ingestion, data transfer, storage and layer design, Cloud Storage, BigLake, BigQuery, Bigtable, Spanner, AlloyDB, open formats, schema evolution, lifecycle, governance, quality, data contracts, data products, sharing, fine-grained security, SLOs, monitoring, cost, and the production deployment model.

It includes 20 full Architecture Decision Records and 16 core Google Cloud service reference cards.

## Diagrams

The `diagrams/` directory contains 10 logical architecture diagrams in six formats each:

- Draw.io (`.drawio`)
- Mermaid (`.mmd`)
- PlantUML (`.puml`)
- Graphviz (`.dot`)
- SVG (`.svg`)
- PNG (`.png`)

## Reference implementations

- `sql/` — BigQuery dataset, table, view, policy, quality, snapshot and recovery examples.
- `examples/` — data contract, data-quality rules, Avro schema and source-to-target mapping examples.
- `checklists/` — source onboarding, data-product certification and production-readiness checklists.

## Quality assurance

- 72-page PDF render verified.
- DOCX accessibility audit: zero high, medium or low findings.
- Heading and style audit reports are included under `docs/`.
- Service capabilities, quotas, regions and product names must be validated against current official Google Cloud documentation before implementation.

## Architecture assumptions

This is a reusable reference baseline, not an organization-specific low-level design. It assumes a global, hybrid and multi-cloud enterprise with petabyte-scale history, regulated data, federated domain ownership, centralized platform controls, and tiered SLO/RPO/RTO targets. Organization-specific requirements must be resolved during discovery and design assurance.
