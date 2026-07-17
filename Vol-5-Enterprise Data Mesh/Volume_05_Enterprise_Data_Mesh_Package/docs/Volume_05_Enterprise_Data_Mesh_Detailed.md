---
title: "Volume 05 - Enterprise Data Mesh"
subtitle: "Enterprise Google Cloud Data Platform Blueprint Series"
author: "Enterprise Data Platform Architecture Office"
date: "2026-07-11"
---

# Document Control

| Attribute | Value |
| --- | --- |
| Document | Volume 05 - Enterprise Data Mesh |
| Series | Enterprise Google Cloud Data Platform Blueprint |
| Version | 1.0 |
| Status | Detailed reference architecture |
| Audience | CDO, CIO, CTO, governance council, domain owners, platform teams, security, analytics, AI and FinOps teams |
| Scope | Domain-oriented data ownership, data products, federated governance, self-service platform, marketplace, access, operating model and example domains |
| Baseline scale | Fortune 100 enterprise, 10-50 PB historical data, 50-250 TB daily ingestion, billions of events per day |
| Primary dependency volumes | Volume 01 Executive Architecture Guide, Volume 02 Landing Zone, Volume 03 Enterprise Data Platform |
| Implementation note | Product capabilities, quotas and regional availability must be validated against current Google Cloud documentation before production implementation |


# Table of Contents

1. Executive Summary  
2. Inherited Enterprise Assumptions  
3. Data Mesh Vision  
4. Data Mesh Principles  
5. Domain Architecture and Decomposition  
6. Ownership and Operating Model  
7. Self-Service Data Platform  
8. Federated Computational Governance  
9. Data Product Lifecycle  
10. Data Contracts and Interfaces  
11. SLOs, Quality, Security, Versioning and Observability  
12. Cost Allocation and FinOps  
13. Marketplace, Discovery, Analytics Hub and Access  
14. Cross-Domain Sharing  
15. Certification and Deprecation  
16. Councils, Stewards and Product Teams  
17. Domain Project, Dataset, IAM and Network Patterns  
18. Governance Model  
19. Maturity Model  
20. Example Domains  
21. Technology and Service Mapping  
22. Architecture Decision Records  
23. Risks and Mitigations  
24. Implementation Roadmap  
25. Validation Checklist  
26. Appendices and Reference Implementations  


## Executive Summary

This volume defines the enterprise data mesh operating and technical architecture for a global Fortune 100
organization. The data mesh is not treated as a tool deployment or a collection of independent marts. It is a
socio-technical architecture in which data is owned by business domains, delivered as governed products,
published through a self-service platform, and controlled through federated computational governance. The
design is intended to scale to petabytes of data, thousands of pipelines, hundreds of data products, and
global regulatory boundaries.

The architecture uses Google Cloud capabilities as the paved road: BigQuery and BigLake for product
interfaces, Cloud Storage for open-format persistence, Dataform and Dataflow for standardized product build
patterns, Knowledge Catalog for discovery and metadata governance, policy tags and data policies for fine-
grained access, Analytics Hub for managed sharing, Cloud Monitoring and Logging for operational telemetry, and
Terraform for repeatable domain provisioning. This follows Google Cloud data mesh guidance that treats data
products as owned, discoverable, governed and consumable assets developed by the teams that best understand
them.

| Executive decision | Recommendation | Reason |
| --- | --- | --- |
| Adopt data-as-a-product | Mandatory | The enterprise cannot scale analytics and AI if curated data remains project-specific and ownerless. |
| Use federated governance | Mandatory | Central policy with domain execution avoids both central bottlenecks and uncontrolled decentralization. |
| Create domain project patterns | Mandatory | A consistent project, dataset and IAM pattern keeps autonomy within security and operational guardrails. |
| Publish products through marketplace | Mandatory for certified products | A single discovery and access path reduces hidden data copies and improves auditability. |
| Use contracts and SLOs | Mandatory | Consumers need stable schemas, documented semantics, measurable freshness and support commitments. |
| Tie cost to product and domain | Mandatory | Data mesh without FinOps becomes decentralized cost sprawl. |
The primary implementation risk is organizational rather than technical: domains must accept ownership for
product quality, support, cost, lifecycle and documentation. The platform team must therefore provide easy
product onboarding, reusable templates, default monitoring, default security controls and automated
publication workflows. The governance council must focus on policy, certification and exception management,
not manual approval of every dataset.



## Inherited Enterprise Assumptions

This volume inherits the enterprise baseline from the previous volumes and resolves open inputs through
explicit planning assumptions. These assumptions are used to produce implementation-ready guidance while
leaving final values open for enterprise approval.

| Category | Assumption | Architecture implication |
| --- | --- | --- |
| Organization | Global Fortune 100 with federated business units | Data mesh will use both central platform teams and domain product teams. |
| Scale | 10-50 PB historical data and 50-250 TB per day | Products require automated metadata, observability and cost controls. |
| Regions | Multiple Google Cloud regions with residency constraints | Policy tags, catalog entries and data products must be location-aware. |
| Consumers | BI, AI, applications, regulators and external partners | Products need multiple interfaces: BigQuery, BigLake, APIs, events and Analytics Hub. |
| Compliance | GDPR, HIPAA, PCI DSS, SOC 2, ISO 27001 and NIST-aligned controls | Data products require classification, lineage, access evidence and retention controls. |
| Operating model | Central platform plus federated domain teams | Responsibilities must be explicit in RACI and product lifecycle gates. |
| Security | Zero Trust and least privilege | Access is purpose-based and time-bound for sensitive products. |


## Data-Mesh Vision

The enterprise data mesh vision is to make high-value enterprise data discoverable, trusted, secure and
reusable across business domains without forcing all data engineering work through a single central delivery
queue. The target state is a marketplace of certified data products, each with a clear owner, semantic
contract, security classification, SLO, cost owner, lineage trail and support model.

The mesh deliberately separates product ownership from platform ownership. Domains own meaning, quality,
prioritization and lifecycle. The platform team owns reusable capabilities, templates, control automation and
platform reliability. The governance function defines the rules and makes them machine-enforceable wherever
possible.

| Outcome | Target state | Success measure |
| --- | --- | --- |
| Speed | Domains can publish approved products without building bespoke infrastructure | New standard data product published in less than 4 weeks after discovery. |
| Trust | Consumers can see owner, lineage, freshness and quality before use | 95% of certified products have complete metadata and active quality rules. |
| Reuse | Products are shared rather than copied into isolated marts | Year-over-year reduction in duplicate curated datasets. |
| Security | Sensitive products apply policy tags, row filters, masking and audited access | 100% of restricted products have automated access evidence. |
| AI readiness | Certified products can safely support AI and RAG use cases | All AI-approved products have semantic descriptions and usage restrictions. |


## Data-Mesh Principles

| Principle | Implementation meaning |
| --- | --- |
| Domain ownership | The domain that understands the business semantics owns the data product, not merely the pipeline. Ownership includes definitions, quality, lifecycle, support and cost. |
| Data as a product | A dataset becomes a product only when it has a consumer-oriented interface, contract, documentation, quality controls, support model and version policy. |
| Self-service with guardrails | Domains should not open platform tickets for every standard product. Provisioning, templates, quality checks, security policies and publication paths are automated. |
| Federated computational governance | Governance policies are centrally defined but enforced through code, metadata, IAM, policy tags, CI/CD checks and catalog workflows. |
| Interoperable product interfaces | Products can be consumed through BigQuery, BigLake, Analytics Hub, APIs, event streams and semantic models depending on consumer needs. |
| Security by classification | Every product is classified, and access controls are derived from classification, purpose, region, consumer role and contractual restrictions. |
| Quality before certification | Products cannot be certified until critical quality, freshness and lineage evidence is available and monitored. |
| Backward-compatible evolution | Product changes must protect consumers through versioning, compatibility rules, deprecation notices and migration windows. |
| Observable products | Freshness, quality, availability, usage, cost and incidents are visible at product and domain level. |
| Cost accountability | Every product is tagged, measured and mapped to domain cost centers. Marketplace consumption supports chargeback or showback. |
| AI-aware semantics | Products intended for AI use include glossary terms, descriptions, policy metadata, sensitivity, lineage and allowed-use statements. |
| Avoid domain silos | Domain autonomy is bounded by common platform standards, shared identity, common governance, certified semantics and cross-domain contracts. |


## Domain Architecture

Domain architecture uses business capability boundaries rather than application ownership alone. A domain
represents a stable area of business accountability with its own source systems, data semantics, product
roadmap, stewards and consumers. The same enterprise may contain strategic domains such as customer, product,
finance and supply chain, plus operational domains such as observability, reference data and workforce.

![Enterprise Data Mesh Reference Architecture](diagrams/png/enterprise_data_mesh_reference.png)

| Domain type | Definition | Example | Ownership pattern |
| --- | --- | --- | --- |
| Core business domain | Domain aligned to a major value stream or business capability | Customer, Finance, Sales, Supply Chain | Business accountable owner and dedicated data product team. |
| Supporting domain | Domain that supports enterprise operations | HR, Legal, Procurement | Named product owner with shared platform engineering support. |
| Reference domain | Domain providing common master or reference entities | Country, Currency, Product Reference | Enterprise stewardship and stricter change control. |
| Platform domain | Domain that provides reusable platform data and telemetry | Cost, Audit, Observability | Owned by central platform and security teams. |
| Analytical aggregate domain | Cross-domain product assembled for enterprise outcomes | Customer 360, Profitability, Demand Forecast | Joint ownership with lead domain and governance council approval. |
Domain decomposition must avoid mirroring every source application. A single domain can consume many
applications, and one application can feed several domains. The deciding questions are: who understands the
semantics, who is accountable for quality, who can approve changes, and who funds the product roadmap.



## Domain Decomposition

| Decomposition criterion | Guidance | Anti-pattern |
| --- | --- | --- |
| Business capability | Start with stable business capabilities and value streams. | Using system names such as SAP or Salesforce as domains. |
| Data ownership | Assign domains where a business owner can be accountable for meaning and quality. | Assigning ownership to a central data engineering queue. |
| Consumer cohesion | Group products consumed together by a coherent audience. | Splitting highly related attributes into unrelated products. |
| Regulatory boundary | Separate domains where regulatory controls or residency rules differ. | Mixing restricted health, HR and marketing data without control boundaries. |
| Change cadence | Separate products with materially different release cadences and risk profiles. | Forcing real-time operational products into monthly finance governance. |
| Cost accountability | Align products with budget owners. | Publishing products without accountable cost centers. |
A practical decomposition workshop should map capabilities, data sources, critical entities, consumers,
regulatory concerns and current pain points. The output is a domain candidate map, not a final organization
chart. Domains mature through pilot products and governance evidence.



## Domain Ownership

Data mesh succeeds only when ownership is explicit and enforceable. Ownership is not a title in a catalog. It
is a commitment to product reliability, quality, change management and support.

| Role | Accountability |
| --- | --- |
| Domain data owner | Accountable for product purpose, business definitions, funding, priorities, risk acceptance and consumer commitments. |
| Data steward | Responsible for glossary, metadata completeness, quality rule interpretation, issue triage and certification evidence. |
| Data product manager | Owns roadmap, demand intake, interface choices, adoption, communication and lifecycle. |
| Data product engineer | Builds pipelines, tables, tests, contracts, deployment automation and monitoring. |
| Analytics engineer | Builds semantic models, certified measures, transformations and BI-friendly interfaces. |
| Platform product team | Owns templates, landing zone integration, CI/CD, catalog integration, marketplace workflows and paved-road standards. |
| Security architect | Approves classification patterns, restricted access patterns and exception handling. |
| FinOps lead | Defines cost allocation, product unit economics and optimization cadence. |


## Data-Product Ownership

A data product is a durable, consumer-oriented data asset. It can be a BigQuery table, an authorized view, a
BigLake table, a Looker semantic model, an Analytics Hub listing, an API, an event stream or a set of
coordinated interfaces. Product ownership is broader than dataset ownership because it includes consumer
commitments and lifecycle management.

| Ownership dimension | Required evidence |
| --- | --- |
| Product identity | Product name, domain, owner, steward, support channel and version. |
| Business semantics | Definitions, glossary terms, grain, allowed-use statement and known limitations. |
| Technical interface | Dataset, view, API, event topic, schema and endpoint documentation. |
| Quality | Rules, thresholds, scorecards, exceptions and remediation owner. |
| Security | Classification, policy tags, row filters, masking, encryption and access approvals. |
| Operations | Freshness SLO, availability SLO, incident runbook and escalation path. |
| Cost | Cost center, labels, consumer charging model and optimization review cadence. |


## Central-Platform Responsibilities

| Central platform responsibility | Description | Not responsible for |
| --- | --- | --- |
| Paved-road provisioning | Reusable project, dataset, IAM, CI/CD, monitoring and catalog templates. | Business prioritization of domain products. |
| Security guardrails | Baseline IAM, VPC SC integration, policy tags, key management and logging. | Approving every low-risk consumer manually. |
| Metadata integration | Common product registration and catalog automation. | Writing domain business definitions. |
| Quality framework | Reusable quality rule engines, scorecard templates and alerting. | Resolving domain source-data defects. |
| Marketplace tooling | Analytics Hub, discovery workflows and access request automation. | Owning consumer relationships for every product. |
| SRE and platform health | Shared platform availability and incident patterns. | Domain-specific freshness and semantic correctness. |
| FinOps enablement | Labels, dashboards, budget alerts and reservation guidance. | Domain product cost accountability. |


## Domain-Team Responsibilities

| Domain-team responsibility | Description | Evidence |
| --- | --- | --- |
| Product roadmap | Prioritize products based on business value and consumer demand. | Quarterly product plan. |
| Source understanding | Document source semantics, quality gaps and lineage. | Source-to-product mapping and glossary. |
| Contract management | Publish and version schemas, quality rules and compatibility policies. | Approved product contract. |
| Build and operate | Implement pipelines, transformations, monitoring and runbooks. | Deployment logs and runbook links. |
| Quality remediation | Investigate failed rules and fix source or transformation issues. | Quality incidents and closure evidence. |
| Consumer enablement | Provide documentation, onboarding and change notices. | Usage guide and communication history. |
| Cost management | Review product consumption, storage and compute spend. | Monthly cost dashboard. |


## Self-Service Data Platform

The self-service data platform is the capability layer that makes domain autonomy practical. It hides repeated
infrastructure tasks behind approved templates and enables product teams to deliver secure products without
bypassing controls. The platform should be product-managed, versioned and measured like any other enterprise
platform.

| Capability | Self-service feature | Control embedded |
| --- | --- | --- |
| Domain onboarding | Project factory creates dev, test and prod domain projects. | Folder placement, billing labels, APIs, IAM groups and logging. |
| Product skeleton | Repository template creates contract, SQL, tests, documentation and monitoring files. | Naming conventions, schema review and CI quality gates. |
| Secure storage | Standard datasets and buckets are provisioned by layer and classification. | CMEK options, retention, policy tags and VPC SC placement. |
| Pipeline templates | Reusable batch, CDC and streaming patterns. | Retry, dead-letter, quality and observability defaults. |
| Catalog registration | Metadata and glossary templates integrate with Knowledge Catalog. | Mandatory owner, steward, classification and support metadata. |
| Marketplace publication | Workflow publishes certified products to Analytics Hub. | Certification gate and approval evidence. |
| Access workflow | Consumers request access through approved groups or listings. | Purpose, classification and recertification controls. |


## Federated Computational Governance

Federated computational governance means policies are expressed in a form that can be evaluated by systems,
not just described in a policy document. The governance council defines the rules; domains execute within
those rules; the platform automates checks and captures evidence.

![Federated Governance Operating Model](diagrams/png/governance_operating_model.png)

| Governance rule | Computational enforcement |
| --- | --- |
| Every product has an owner | CI/CD blocks publication if owner metadata is absent. |
| Restricted columns are tagged | Schema deployment validates policy tags for sensitive fields. |
| Quality thresholds are monitored | Data quality scans and assertions publish scorecards. |
| Breaking changes are controlled | Contract compatibility checks fail incompatible releases without approved major version. |
| Products have SLOs | Monitoring policies are created from contract metadata. |
| Costs are allocated | Required labels and billing export validation are part of product deployment. |
| Access is purposeful | Access workflow records requester, purpose, approver, expiry and classification. |


## Data-Product Lifecycle

The product lifecycle is a managed flow from demand to retirement. Each gate produces evidence that is useful
to consumers, governance, security and operations. The lifecycle should be automated through repository
templates, CI/CD, catalog APIs, quality scans and access workflows.

![Data Product Lifecycle](diagrams/png/data_product_lifecycle.png)

| Stage | Activities | Exit criteria |
| --- | --- | --- |
| Demand intake | Capture use case, consumers, value, data sources and risk. | Product candidate has sponsor, owner and priority. |
| Design | Define grain, schema, interface, SLOs, classification and cost model. | Contract approved by owner, steward and architecture reviewer. |
| Build | Implement ingestion, transformation, tests, documentation and monitoring. | All automated tests pass in non-production. |
| Validate | Run quality, security, lineage, performance and cost checks. | Certification evidence produced. |
| Publish | Register metadata and expose through approved interface or Analytics Hub. | Consumers can discover and request access. |
| Operate | Monitor freshness, quality, usage, incidents and cost. | SLO dashboard and runbook active. |
| Evolve | Release compatible changes or new major version. | Consumers notified and migration plan created. |
| Deprecate | Mark replacement, freeze changes and schedule retirement. | No active consumers or exception approved. |


## Data Contracts

A data contract is the enforceable promise between a producer and consumers. It is not only a schema. It
includes semantics, ownership, quality, security, freshness, interface, compatibility, change and support
obligations. Contracts should be stored in source control, deployed through CI/CD, and reflected in the
catalog.

![Data Contract Reference Structure](diagrams/png/data_contract_reference.png)

| Contract element | Required content | Validation method |
| --- | --- | --- |
| Identity | Product name, domain, owner, steward, support and version. | Contract linter checks mandatory fields. |
| Schema | Field names, types, descriptions, nullability, primary keys and grain. | Schema compatibility test. |
| Semantics | Business definitions, glossary terms and permitted use. | Steward review and catalog sync. |
| Quality | Rules, thresholds, severity and remediation owner. | Dataform assertions or quality scans. |
| Security | Classification, policy tags, masking, row filters and access conditions. | Policy validation and security review. |
| Freshness | Expected update frequency, latency SLO and incident severity. | Monitoring policy generated from contract. |
| Compatibility | Allowed additive changes, breaking-change process and deprecation period. | CI/CD compatibility gate. |
| Cost | Cost center, chargeback model and consumer impact. | Billing labels and cost dashboard. |


## Data-Product Interfaces

| Interface type | Use case | Google Cloud pattern | Design controls |
| --- | --- | --- | --- |
| BigQuery table | Internal analytical consumption with direct SQL access. | Certified table in product dataset. | Dataset IAM, policy tags, row policies and monitoring. |
| Authorized view | Filtered or transformed access to sensitive data. | View in sharing dataset authorized to source. | No direct source access for consumer. |
| Analytics Hub listing | Managed sharing inside or across organizational boundaries. | Exchange and listing for certified product. | Subscription workflow, documentation and audit. |
| BigLake table | Open-format lakehouse data queried through BigQuery. | BigLake table over Cloud Storage objects. | Fine-grained access without bucket read permissions. |
| Looker semantic model | Governed measures and dashboard consistency. | LookML model over certified data. | Metric certification and role-based access. |
| API | Operational or application consumption. | Cloud Run or Apigee backed by product data. | Authentication, quota, audit and data minimization. |
| Event stream | Near-real-time product changes. | Pub/Sub topic with versioned schema. | Schema evolution, dead-lettering and replay policy. |


## Data-Product SLOs

| SLO category | Example target | Measurement | Owner |
| --- | --- | --- | --- |
| Freshness | 95% of product updates available within 15 minutes for Tier 1 products. | Max source event time to product availability. | Domain product team. |
| Availability | 99.9% monthly availability for certified product interface. | Successful query/API/listing availability. | Domain plus platform. |
| Correctness | Critical quality rules pass at 99.5% or approved exception. | Quality scorecard and rule results. | Data steward. |
| Completeness | Required source coverage meets published threshold. | Source reconciliation reports. | Data product engineer. |
| Support | Priority 1 incident response within 30 minutes. | Incident system timestamps. | Product owner. |
| Change notice | Breaking change notice at least 90 days before retirement. | Consumer communication log. | Data product manager. |


## Data-Product Quality

| Quality dimension | Rule example | Certification threshold |
| --- | --- | --- |
| Completeness | customer_id is not null. | 100% for primary entity products. |
| Uniqueness | product key is unique for effective timestamp. | 100% for keys. |
| Validity | status is in approved reference set. | 99.9% unless exception documented. |
| Consistency | region_code matches residency rules. | 100% for restricted products. |
| Timeliness | latest partition loaded within SLO. | 95-99% by product tier. |
| Accuracy | financial totals reconcile with source ledger. | 100% for regulatory products. |
| Referential integrity | foreign keys match certified reference products. | 99.9% or remediation plan. |
| Drift | schema and distribution changes are detected. | Alert on unexpected material drift. |


## Data-Product Security

| Security control | Data mesh implementation |
| --- | --- |
| Classification | Product and field classification stored in contract and catalog. |
| Policy tags | Sensitive columns use taxonomy-aligned policy tags. |
| Dynamic masking | PII and restricted attributes masked by default for broad consumer groups. |
| Row access policies | Regional, tenant, legal entity and purpose restrictions enforced in BigQuery. |
| Authorized views | Consumers access filtered views where direct table access is not justified. |
| Analytics Hub controls | Listings expose only approved products with documented usage terms. |
| IAM groups | Access assigned to groups, not individual users, except temporary break-glass. |
| Audit evidence | Access requests, query logs and product changes are retained for control testing. |
| VPC SC alignment | Restricted products remain inside approved service perimeters where applicable. |


## Data-Product Versioning

| Change type | Version rule | Consumer impact |
| --- | --- | --- |
| Add nullable column | Minor version; compatible. | No migration required. |
| Add required column | Major version unless defaulted. | Consumer migration required. |
| Rename column | Major version. | Old version maintained during deprecation period. |
| Change type | Major version unless safe widening. | Compatibility test required. |
| Change definition | Minor or major depending on semantic impact. | Consumer notice required. |
| Change freshness SLO | Contract update and approval. | Consumers must accept new SLO. |
| Remove product | Deprecation and retirement workflow. | Replacement and migration plan required. |


## Data-Product Observability

| Observable signal | Metric | Dashboard view |
| --- | --- | --- |
| Freshness | Source event time to product availability. | Product SLO dashboard. |
| Quality | Rule pass rate and failed-record count. | Quality scorecard. |
| Usage | Queries, consumers, subscriptions and API calls. | Adoption dashboard. |
| Cost | Storage, compute, pipeline and BI cost by product. | FinOps dashboard. |
| Reliability | Failures, retries, backlog and error budget. | Operations dashboard. |
| Security | Access grants, denied attempts and sensitive queries. | Security dashboard. |
| Lineage | Upstream sources and downstream consumers. | Catalog and lineage view. |


## Data-Product Cost Allocation

Product-level cost accountability prevents a mesh from becoming a collection of expensive duplications. Costs
are tagged at project, dataset, table, job, pipeline and listing levels wherever possible. Billing export to
BigQuery provides the measurement source for showback and chargeback.

| Cost area | Allocation method | Optimization practice |
| --- | --- | --- |
| Storage | Dataset and table labels mapped to product. | Lifecycle policies, partition pruning and duplicate detection. |
| BigQuery compute | Reservation assignments, job labels and user group mapping. | Slot baselines, query standards and materialized views. |
| Pipeline compute | Dataflow, Dataproc and Composer labels. | Autoscaling, right-sizing and schedule optimization. |
| Marketplace consumption | Consumer subscription or query attribution. | Chargeback by consumer domain for high-cost products. |
| Logging and monitoring | Product and pipeline labels. | Log exclusions and metric retention tiers. |
| AI consumption | Model, vector index and product labels. | Token budgets and approved AI product tiers. |


## Data Marketplace

The data marketplace is the user-facing expression of the mesh. It should allow consumers to discover
products, understand trust indicators, compare alternatives, request access, view documentation, inspect
lineage, and understand usage obligations. Analytics Hub is used for managed sharing of BigQuery and BigLake-
backed data products, while Knowledge Catalog provides broader metadata, glossary and discovery context.

| Marketplace capability | Required behavior |
| --- | --- |
| Search | Search by business term, domain, owner, classification, product name and use case. |
| Trust indicators | Show certification, quality score, freshness, lineage completeness and support tier. |
| Access request | Trigger controlled approval workflow based on classification and purpose. |
| Documentation | Expose contract, schema, examples, definitions and limitations. |
| Subscription | Provision Analytics Hub subscription or IAM binding through approved automation. |
| Feedback | Allow consumers to report defects, request enhancements and rate product usefulness. |
| Lifecycle visibility | Show current, deprecated and replacement products. |


## Data Discovery

Discovery begins with catalog completeness. A product should not be discoverable as certified unless it has a
meaningful description, glossary alignment, owner, steward, classification, quality status, lineage, version
and interface documentation. Knowledge Catalog is the system of record for context, while repository metadata
remains the source of deployment truth.

| Discovery metadata | Why it matters |
| --- | --- |
| Business description | Allows non-engineers to determine relevance. |
| Glossary terms | Aligns product semantics with enterprise vocabulary. |
| Owner and steward | Establishes accountability and support route. |
| Classification | Prevents inappropriate access requests. |
| Lineage | Shows trust, dependencies and impact. |
| Quality score | Shows whether the product is fit for purpose. |
| Example query | Accelerates safe adoption. |
| Allowed use | Prevents misuse in regulatory or AI-sensitive contexts. |


## Analytics Hub

Analytics Hub provides a managed publication and subscription pattern for data products. The mesh uses
exchanges for enterprise-wide sharing and domain-specific exchanges for bounded sharing. High-sensitivity
products should be exposed through authorized views, filtered listings or request-only workflows rather than
broad subscriptions.

| Exchange pattern | Use case | Control |
| --- | --- | --- |
| Enterprise certified exchange | Approved cross-domain products for broad internal consumption. | Certification required before publication. |
| Restricted exchange | Sensitive products requiring explicit approval. | Purpose-based approval and recertification. |
| Partner exchange | Approved partner or external sharing. | Legal agreement, VPC SC review and data minimization. |
| Domain exchange | Products intended primarily for domain consumers. | Domain owner approval. |
| AI-ready exchange | Products approved for AI or RAG use. | Responsible AI and sensitive-data controls. |


## Access-Request Workflows

Access workflows must balance speed and control. Low-risk certified products can use group-based self-service
subscription with automated approval. Restricted or regulated products require owner and security review,
explicit purpose, expiry, logging, recertification and revocation controls.

![Access Request and Fulfillment Workflow](diagrams/png/access_workflow.png)

| Step | Description | Evidence |
| --- | --- | --- |
| Discover | Consumer finds product in catalog or marketplace. | Search and product view audit. |
| Request | Consumer states purpose, project, duration and data elements. | Ticket or workflow record. |
| Classify | Workflow checks product classification and requester group. | Automated policy evaluation. |
| Approve | Owner, steward, privacy or security approve as required. | Approval record. |
| Provision | IAM, authorized view or subscription is applied. | Infrastructure or policy change log. |
| Monitor | Queries, exports and anomalies are monitored. | Audit and security telemetry. |
| Recertify | Access is reviewed periodically. | Access review evidence. |
| Revoke | Expired or inappropriate access is removed. | Revocation log. |


## Cross-Domain Sharing

Cross-domain sharing is achieved through data contracts, certified product interfaces and marketplace
patterns, not through uncontrolled dataset copies. When a product depends on another domain, the consuming
domain should treat the upstream product as a contracted dependency with defined SLOs and change
notifications.

| Sharing pattern | Appropriate use | Risk control |
| --- | --- | --- |
| Direct BigQuery access | Trusted internal consumers with low sensitivity. | Dataset IAM and job labels. |
| Authorized views | Sensitive attributes or regional filters. | No raw table access. |
| Analytics Hub subscription | Reusable product consumption across teams. | Subscription tracking and marketplace terms. |
| Product copy | Only where residency, performance or isolation requires it. | Lineage and copy lifecycle controls. |
| API access | Operational applications and fine-grained request controls. | Authentication, quotas and request audit. |
| Event subscription | Near-real-time downstream product builds. | Schema versioning and DLQ. |


## Data-Product Certification

| Certification gate | Mandatory evidence |
| --- | --- |
| Ownership | Named owner, steward, product manager and support channel. |
| Contract | Approved versioned contract with schema and semantics. |
| Security | Classification, policy tags, masking and access pattern approved. |
| Quality | Critical rules automated with passing score or approved exception. |
| Lineage | Upstream and downstream lineage registered or documented. |
| SLO | Freshness, availability, support and incident severity defined. |
| Observability | Dashboard and alerting active. |
| Cost | Labels, cost center and dashboard in place. |
| Documentation | Catalog record has examples, limitations and permitted uses. |
| Review | Governance or delegated reviewer approves publication. |


## Data-Product Deprecation

| Deprecation step | Requirement |
| --- | --- |
| Mark deprecated | Catalog and marketplace show deprecated status and replacement. |
| Notify consumers | Active consumers receive notice through approved channels. |
| Freeze breaking changes | Only critical fixes allowed after deprecation. |
| Migration window | Minimum window depends on tier, typically 90-180 days for certified products. |
| Monitor usage | Usage dashboard confirms consumer migration. |
| Remove access | Subscriptions and IAM are revoked after retirement date. |
| Archive evidence | Contract, lineage, quality and access evidence retained. |


## Governance Council, Owners, Stewards and Platform Team

| Body or role | Primary purpose | Decision rights |
| --- | --- | --- |
| Data Governance Council | Set policies, approve standards, resolve cross-domain conflicts. | Enterprise policy, certification criteria and exception acceptance. |
| Chief Data Office | Own data strategy, maturity, adoption and governance outcomes. | Prioritization, funding model and stewardship model. |
| Domain Data Owner | Accountable for domain products and risk. | Product approval, quality exceptions and consumer commitments. |
| Data Steward | Manage definitions, metadata, quality and certification evidence. | Glossary terms and quality rule interpretation. |
| Platform Product Team | Build and operate self-service platform capabilities. | Template standards, automation releases and platform roadmap. |
| Security and Privacy | Approve sensitive-data access patterns and control mappings. | Restricted access, masking standards and exception review. |
| FinOps Council | Review product cost and optimization. | Budget alerts, chargeback rules and commitment planning. |


## Domain Platform Patterns

The domain platform pattern provides a repeatable physical model for domain autonomy. Each domain receives
separate non-production and production projects, standardized datasets, controlled service accounts, catalog
integration and pipeline templates. Restricted products may be isolated in separate projects or datasets
depending on classification and service perimeter design.

![Domain Project and Dataset Pattern](diagrams/png/domain_project_pattern.png)

| Project type | Purpose | Typical resources |
| --- | --- | --- |
| domain-dev | Development and unit testing. | Datasets, buckets, Dataform workspace, test topics, temporary compute. |
| domain-test | Integration testing and certification evidence. | Representative data, CI tests, validation scans. |
| domain-prod | Production products and pipelines. | Certified datasets, scheduled pipelines, monitoring. |
| domain-restricted-prod | Highly sensitive products requiring stricter boundaries. | Restricted datasets, CMEK, VPC SC placement, limited IAM. |
| marketplace | Exchange, listings and authorized sharing views. | Analytics Hub exchanges, sharing datasets. |
| domain-sandbox | Controlled experimentation with synthetic or de-identified data. | Quota-limited datasets and notebooks. |


## Domain Dataset Structure

| Dataset pattern | Purpose | Access rule |
| --- | --- | --- |
| <domain>_raw | Immutable source-aligned records. | Producer and engineering access only. |
| <domain>_silver | Standardized, cleaned and conformed records. | Domain engineering and approved dependencies. |
| <domain>_gold | Domain-consumption models. | Approved domain consumers. |
| <domain>_products | Certified products for broad sharing. | Published through views, listings or controlled IAM. |
| <domain>_restricted | Sensitive product data. | Purpose-based access and stronger controls. |
| <domain>_quality | Quality results, rule outputs and scorecards. | Steward and platform operations access. |
| <domain>_audit | Product usage, access and operational evidence. | Domain, security and audit access. |


## Data-Mesh IAM Model

The IAM model uses groups for humans, dedicated service accounts for workloads, and product-specific access
bindings. Direct user-level grants are avoided except for time-bound break-glass events. Access to products is
based on consumer role, purpose, classification, residency and product interface.

![Data Mesh IAM and Trust Boundaries](diagrams/png/data_mesh_iam_model.png)

| Principal | Grant pattern | Notes |
| --- | --- | --- |
| Domain engineers | Project-level development roles in dev/test, limited production deployment role. | Production changes through CI/CD. |
| Data stewards | Metadata and quality result access; limited data access based on need. | Steward does not automatically get restricted data. |
| Product pipelines | Dedicated service account per product or product family. | Least privilege to source, target and quality datasets. |
| Consumers | Group-based access to views/listings; no raw access by default. | Access recertified periodically. |
| Security reviewers | Read metadata, audit logs and policy evidence. | Restricted data access only when required and approved. |
| Break-glass | Time-bound elevated group with mandatory review. | All actions logged and reviewed. |


## Data-Mesh Network Model

The network model inherits the landing-zone Shared VPC and private access strategy. Data mesh products do not
create independent network islands. Domain projects attach to approved host projects, use Private Google
Access and Private Service Connect where appropriate, and follow service perimeter boundaries for restricted
data. Cross-domain consumption should occur through product interfaces rather than direct private network
paths between arbitrary projects.

| Network requirement | Pattern |
| --- | --- |
| Domain isolation | Separate projects and IAM boundaries rather than separate bespoke VPCs for every product. |
| Private access | Use private paths to Google APIs for production data movement. |
| Restricted perimeter | Place restricted products and pipelines in defined VPC SC perimeters where supported. |
| Hybrid sources | Route source ingestion through approved interconnect or VPN patterns defined in landing zone. |
| Cross-domain consumption | Prefer BigQuery, Analytics Hub, authorized views and APIs over lateral network access. |
| Partner sharing | Use approved external sharing patterns with legal, security and data minimization controls. |


## Data-Mesh Governance Model

The governance model defines mandatory policies once and implements them through reusable controls. The goal
is not to review every table manually; it is to create automated evidence that shows whether products meet
standards. Exceptions are allowed but must be recorded, owned, time-bound and reviewed.

| Governance area | Policy | Automation |
| --- | --- | --- |
| Ownership | Every certified product has owner and steward. | Contract linter and catalog completeness check. |
| Classification | Every product and sensitive field is classified. | Schema scanner and policy-tag validation. |
| Quality | Certified products have active quality rules. | Dataform assertions and Knowledge Catalog data quality scans. |
| Lineage | Products have source and transformation lineage. | Pipeline metadata and catalog lineage. |
| Access | Restricted access requires approval and expiry. | Workflow and IAM automation. |
| Lifecycle | Deprecated products have replacement and retirement date. | Marketplace status and usage monitoring. |
| Cost | Products carry domain and cost-center labels. | Billing export validation. |


## Data-Mesh Maturity Model

| Maturity level | Characteristics | Exit criteria |
| --- | --- | --- |
| Level 1 - Ad hoc | Datasets exist but ownership, quality and documentation are inconsistent. | Critical products identified and owners assigned. |
| Level 2 - Managed | Domain teams publish documented products with manual governance. | Standard contracts, quality rules and access patterns used by pilots. |
| Level 3 - Standardized | Self-service templates and catalog integration are broadly used. | Most certified products follow common lifecycle and SLO model. |
| Level 4 - Measured | Product usage, quality, SLOs and cost are measured enterprise-wide. | Quarterly product reviews and FinOps routines active. |
| Level 5 - Optimized | Governance is largely computational and products support AI safely. | Automated controls, high reuse and low duplicate product rate. |


## Example Domain: Healthcare

Manage patient, clinical, encounter, claims, provider and care-management data products for analytics,
regulatory reporting and AI-assisted care operations.

| Dimension | Design |
| --- | --- |
| Domain purpose | Manage patient, clinical, encounter, claims, provider and care-management data products for analytics, regulatory reporting and AI-assisted care operations. |
| Data sources | EHR, HL7/FHIR feeds, claims systems, lab systems, pharmacy, imaging metadata, patient engagement portals, provider directories. |
| Domain owner | Chief Medical Information Officer or VP Clinical Data |
| Data steward | Clinical Data Steward |
| Key data products | Patient 360, Encounter Summary, Claims Analytics, Provider Network, Care Gap Registry |
| Product consumers | Care management, clinical analytics, regulatory reporting, population health, AI care-assist teams |
| Security classification | Restricted - PHI and confidential clinical data |
| SLOs | Tier 1 for care operations; 15 minute to 4 hour freshness depending on source |
| Access model | Authorized views, policy tags, row filters by region/provider, audit-heavy access, no broad raw access |
| Cost-allocation model | Chargeback to clinical operations, population health and regulatory reporting cost centers. |
| Data product | Primary interface | Contract highlights |
| --- | --- | --- |
| Patient 360 | BigQuery certified table, authorized view or Analytics Hub listing | Owner, steward, schema, quality rules, classification, SLO, versioning and support defined. |
| Encounter Summary | BigQuery certified table, authorized view or Analytics Hub listing | Owner, steward, schema, quality rules, classification, SLO, versioning and support defined. |
| Claims Analytics | BigQuery certified table, authorized view or Analytics Hub listing | Owner, steward, schema, quality rules, classification, SLO, versioning and support defined. |
| Provider Network | BigQuery certified table, authorized view or Analytics Hub listing | Owner, steward, schema, quality rules, classification, SLO, versioning and support defined. |
| Care Gap Registry | BigQuery certified table, authorized view or Analytics Hub listing | Owner, steward, schema, quality rules, classification, SLO, versioning and support defined. |
| Quality rule | Severity | Action |
| --- | --- | --- |
| Patient identifier completeness 100% | Critical | Block certification or route to steward remediation. |
| Encounter date validity 99.9% | High | Block certification or route to steward remediation. |
| FHIR resource conformance 99% | High | Block certification or route to steward remediation. |
| Claims reconciliation 100% for financial reporting | Critical | Block certification or route to steward remediation. |
| Project or dataset | Example naming |
| --- | --- |
| Development project | prj-healthcare-dev |
| Production project | prj-healthcare-prod |
| Restricted project | prj-healthcare-restricted-prod |
| Product dataset | healthcare_products |
| Quality dataset | healthcare_quality |
| Audit dataset | healthcare_audit |


## Example Domain: Finance

Provide governed financial, ledger, profitability, treasury, risk and regulatory reporting data products.

| Dimension | Design |
| --- | --- |
| Domain purpose | Provide governed financial, ledger, profitability, treasury, risk and regulatory reporting data products. |
| Data sources | ERP, general ledger, subledger, treasury, billing, payments, procurement, tax and risk systems. |
| Domain owner | Corporate Controller or Finance Data Owner |
| Data steward | Finance Data Steward |
| Key data products | General Ledger Gold, Profitability Cube, Revenue Recognition, Expense Analytics, Regulatory Finance Pack |
| Product consumers | FP&A, accounting, treasury, auditors, regulatory reporting, executive dashboards |
| Security classification | Confidential to restricted depending on legal entity and regulatory scope |
| SLOs | Tier 0 for close and regulatory periods; Tier 1 otherwise |
| Access model | Authorized views by legal entity, finance role and close-period status; strict audit retention |
| Cost-allocation model | Chargeback to finance shared services and consuming business units. |
| Data product | Primary interface | Contract highlights |
| --- | --- | --- |
| General Ledger Gold | BigQuery certified table, authorized view or Analytics Hub listing | Owner, steward, schema, quality rules, classification, SLO, versioning and support defined. |
| Profitability Cube | BigQuery certified table, authorized view or Analytics Hub listing | Owner, steward, schema, quality rules, classification, SLO, versioning and support defined. |
| Revenue Recognition | BigQuery certified table, authorized view or Analytics Hub listing | Owner, steward, schema, quality rules, classification, SLO, versioning and support defined. |
| Expense Analytics | BigQuery certified table, authorized view or Analytics Hub listing | Owner, steward, schema, quality rules, classification, SLO, versioning and support defined. |
| Regulatory Finance Pack | BigQuery certified table, authorized view or Analytics Hub listing | Owner, steward, schema, quality rules, classification, SLO, versioning and support defined. |
| Quality rule | Severity | Action |
| --- | --- | --- |
| Debit/credit reconciliation 100% | Critical | Block certification or route to steward remediation. |
| Currency code validity 100% | Critical | Block certification or route to steward remediation. |
| Close-period immutability enforced | High | Block certification or route to steward remediation. |
| Legal-entity mapping 100% | Critical | Block certification or route to steward remediation. |
| Project or dataset | Example naming |
| --- | --- |
| Development project | prj-finance-dev |
| Production project | prj-finance-prod |
| Restricted project | prj-finance-restricted-prod |
| Product dataset | finance_products |
| Quality dataset | finance_quality |
| Audit dataset | finance_audit |


## Example Domain: Human Resources

Provide workforce, position, payroll, skills, learning and organization data products with strict privacy
controls.

| Dimension | Design |
| --- | --- |
| Domain purpose | Provide workforce, position, payroll, skills, learning and organization data products with strict privacy controls. |
| Data sources | Workday, payroll, learning systems, identity systems, recruiting and performance systems. |
| Domain owner | Chief Human Resources Officer delegate |
| Data steward | Workforce Data Steward |
| Key data products | Workforce Headcount, Organization Hierarchy, Skills Inventory, Attrition Analytics, Payroll Controls |
| Product consumers | HR analytics, workforce planning, finance, access governance, selected executives |
| Security classification | Restricted - employee personal and compensation data |
| SLOs | Tier 1 for identity-impacting workforce products; daily for planning products |
| Access model | Default masked compensation and demographic data; purpose-based access with expiry |
| Cost-allocation model | HR cost center with chargeback for enterprise planning products. |
| Data product | Primary interface | Contract highlights |
| --- | --- | --- |
| Workforce Headcount | BigQuery certified table, authorized view or Analytics Hub listing | Owner, steward, schema, quality rules, classification, SLO, versioning and support defined. |
| Organization Hierarchy | BigQuery certified table, authorized view or Analytics Hub listing | Owner, steward, schema, quality rules, classification, SLO, versioning and support defined. |
| Skills Inventory | BigQuery certified table, authorized view or Analytics Hub listing | Owner, steward, schema, quality rules, classification, SLO, versioning and support defined. |
| Attrition Analytics | BigQuery certified table, authorized view or Analytics Hub listing | Owner, steward, schema, quality rules, classification, SLO, versioning and support defined. |
| Payroll Controls | BigQuery certified table, authorized view or Analytics Hub listing | Owner, steward, schema, quality rules, classification, SLO, versioning and support defined. |
| Quality rule | Severity | Action |
| --- | --- | --- |
| Employee ID uniqueness 100% | Critical | Block certification or route to steward remediation. |
| Manager hierarchy validity 99.9% | High | Block certification or route to steward remediation. |
| Compensation fields tagged and masked | High | Block certification or route to steward remediation. |
| Termination status freshness daily | High | Block certification or route to steward remediation. |
| Project or dataset | Example naming |
| --- | --- |
| Development project | prj-human-resources-dev |
| Production project | prj-human-resources-prod |
| Restricted project | prj-human-resources-restricted-prod |
| Product dataset | human_resources_products |
| Quality dataset | human_resources_quality |
| Audit dataset | human_resources_audit |


## Example Domain: Sales

Provide opportunity, account, pipeline, quota, booking and territory data products for revenue operations.

| Dimension | Design |
| --- | --- |
| Domain purpose | Provide opportunity, account, pipeline, quota, booking and territory data products for revenue operations. |
| Data sources | CRM, CPQ, order management, partner portal, territory systems, sales forecasting tools. |
| Domain owner | Chief Revenue Officer delegate |
| Data steward | Sales Operations Data Steward |
| Key data products | Pipeline Forecast, Account 360, Bookings Gold, Territory Assignment, Sales Activity Metrics |
| Product consumers | Sales operations, finance, marketing, executive dashboards, AI forecasting teams |
| Security classification | Confidential with restricted customer and contract details |
| SLOs | Hourly for pipeline and bookings; daily for territory snapshots |
| Access model | Role-based views by region, segment and management hierarchy |
| Cost-allocation model | Revenue operations cost center and showback to sales regions. |
| Data product | Primary interface | Contract highlights |
| --- | --- | --- |
| Pipeline Forecast | BigQuery certified table, authorized view or Analytics Hub listing | Owner, steward, schema, quality rules, classification, SLO, versioning and support defined. |
| Account 360 | BigQuery certified table, authorized view or Analytics Hub listing | Owner, steward, schema, quality rules, classification, SLO, versioning and support defined. |
| Bookings Gold | BigQuery certified table, authorized view or Analytics Hub listing | Owner, steward, schema, quality rules, classification, SLO, versioning and support defined. |
| Territory Assignment | BigQuery certified table, authorized view or Analytics Hub listing | Owner, steward, schema, quality rules, classification, SLO, versioning and support defined. |
| Sales Activity Metrics | BigQuery certified table, authorized view or Analytics Hub listing | Owner, steward, schema, quality rules, classification, SLO, versioning and support defined. |
| Quality rule | Severity | Action |
| --- | --- | --- |
| Opportunity amount non-negative 100% | Critical | Block certification or route to steward remediation. |
| Close date validity 99% | High | Block certification or route to steward remediation. |
| Territory assignment completeness 99.5% | High | Block certification or route to steward remediation. |
| Bookings reconciliation with finance 100% | Critical | Block certification or route to steward remediation. |
| Project or dataset | Example naming |
| --- | --- |
| Development project | prj-sales-dev |
| Production project | prj-sales-prod |
| Restricted project | prj-sales-restricted-prod |
| Product dataset | sales_products |
| Quality dataset | sales_quality |
| Audit dataset | sales_audit |


## Example Domain: Marketing

Provide campaign, consent, audience, engagement and attribution products for growth and personalization.

| Dimension | Design |
| --- | --- |
| Domain purpose | Provide campaign, consent, audience, engagement and attribution products for growth and personalization. |
| Data sources | Marketing automation, web analytics, consent management, ad platforms, CRM, customer data platform. |
| Domain owner | Chief Marketing Officer delegate |
| Data steward | Marketing Data Steward |
| Key data products | Campaign Performance, Audience Segments, Consent Status, Attribution Model, Lead Funnel |
| Product consumers | Marketing analytics, sales, digital teams, AI personalization, privacy operations |
| Security classification | Confidential; restricted where PII, consent or tracking identifiers are used |
| SLOs | Near real time for consent; hourly or daily for analytics |
| Access model | Consent-aware views, masking of direct identifiers, strict allowed-use statements |
| Cost-allocation model | Marketing operations with product-level showback for activation workloads. |
| Data product | Primary interface | Contract highlights |
| --- | --- | --- |
| Campaign Performance | BigQuery certified table, authorized view or Analytics Hub listing | Owner, steward, schema, quality rules, classification, SLO, versioning and support defined. |
| Audience Segments | BigQuery certified table, authorized view or Analytics Hub listing | Owner, steward, schema, quality rules, classification, SLO, versioning and support defined. |
| Consent Status | BigQuery certified table, authorized view or Analytics Hub listing | Owner, steward, schema, quality rules, classification, SLO, versioning and support defined. |
| Attribution Model | BigQuery certified table, authorized view or Analytics Hub listing | Owner, steward, schema, quality rules, classification, SLO, versioning and support defined. |
| Lead Funnel | BigQuery certified table, authorized view or Analytics Hub listing | Owner, steward, schema, quality rules, classification, SLO, versioning and support defined. |
| Quality rule | Severity | Action |
| --- | --- | --- |
| Consent status freshness under 15 minutes | Critical | Block certification or route to steward remediation. |
| Campaign ID validity 99.5% | High | Block certification or route to steward remediation. |
| No activation without consent rule | Critical | Block certification or route to steward remediation. |
| Attribution completeness threshold by channel | High | Block certification or route to steward remediation. |
| Project or dataset | Example naming |
| --- | --- |
| Development project | prj-marketing-dev |
| Production project | prj-marketing-prod |
| Restricted project | prj-marketing-restricted-prod |
| Product dataset | marketing_products |
| Quality dataset | marketing_quality |
| Audit dataset | marketing_audit |


## Example Domain: Supply Chain

Provide supplier, inventory, logistics, demand, order fulfillment and resilience data products.

| Dimension | Design |
| --- | --- |
| Domain purpose | Provide supplier, inventory, logistics, demand, order fulfillment and resilience data products. |
| Data sources | ERP, warehouse management, transportation management, supplier portals, IoT sensors, planning systems. |
| Domain owner | Chief Supply Chain Officer delegate |
| Data steward | Supply Chain Data Steward |
| Key data products | Inventory Position, Supplier Risk, Demand Forecast Inputs, Shipment Visibility, Order Fulfillment |
| Product consumers | Operations, procurement, finance, sales, risk, AI demand planning |
| Security classification | Confidential with restricted supplier and contractual terms |
| SLOs | Minutes for shipment visibility; hourly/daily for planning products |
| Access model | Views by business unit, region and supplier confidentiality; partner sharing by contract |
| Cost-allocation model | Supply chain operations and consuming planning teams. |
| Data product | Primary interface | Contract highlights |
| --- | --- | --- |
| Inventory Position | BigQuery certified table, authorized view or Analytics Hub listing | Owner, steward, schema, quality rules, classification, SLO, versioning and support defined. |
| Supplier Risk | BigQuery certified table, authorized view or Analytics Hub listing | Owner, steward, schema, quality rules, classification, SLO, versioning and support defined. |
| Demand Forecast Inputs | BigQuery certified table, authorized view or Analytics Hub listing | Owner, steward, schema, quality rules, classification, SLO, versioning and support defined. |
| Shipment Visibility | BigQuery certified table, authorized view or Analytics Hub listing | Owner, steward, schema, quality rules, classification, SLO, versioning and support defined. |
| Order Fulfillment | BigQuery certified table, authorized view or Analytics Hub listing | Owner, steward, schema, quality rules, classification, SLO, versioning and support defined. |
| Quality rule | Severity | Action |
| --- | --- | --- |
| SKU validity 99.9% | High | Block certification or route to steward remediation. |
| Inventory balance reconciliation 99.5% | High | Block certification or route to steward remediation. |
| Shipment event ordering rules | High | Block certification or route to steward remediation. |
| Supplier ID completeness 100% | Critical | Block certification or route to steward remediation. |
| Project or dataset | Example naming |
| --- | --- |
| Development project | prj-supply-chain-dev |
| Production project | prj-supply-chain-prod |
| Restricted project | prj-supply-chain-restricted-prod |
| Product dataset | supply_chain_products |
| Quality dataset | supply_chain_quality |
| Audit dataset | supply_chain_audit |


## Technology and Service Mapping

| Capability | Primary Google Cloud services | Selection rationale |
| --- | --- | --- |
| Product storage and SQL interface | BigQuery, BigLake, Cloud Storage | Supports native warehouse products and open-format lakehouse products. |
| Product discovery and context | Knowledge Catalog | Provides enterprise context, metadata, governance, data profiling and quality capabilities. |
| Managed sharing | Analytics Hub | Supports managed exchanges and listings for data products. |
| Transformation and product build | Dataform, BigQuery SQL, Dataflow | Supports SQL products, batch/stream pipelines and automated tests. |
| Security and access | IAM, policy tags, data policies, row access policies, VPC SC | Provides layered least-privilege and fine-grained controls. |
| Observability | Cloud Monitoring, Cloud Logging, BigQuery INFORMATION_SCHEMA | Provides freshness, quality, reliability, usage and cost signals. |
| Automation | Terraform, Cloud Build, Artifact Registry | Provides repeatable domain and product provisioning. |
| AI-ready consumption | Vertex AI, BigQuery, Knowledge Catalog | Allows certified products to support AI and RAG with governed context. |
| Service | Purpose | Benefits | Limitations / validation |
| --- | --- | --- | --- |
| BigQuery | Analytical data product serving layer. | Serverless SQL, fine-grained security, scalable analytics. | Partitioning, clustering, reservations and cost controls require active design. |
| BigLake | Governed open-format data access through BigQuery. | Fine-grained access to Cloud Storage data without direct bucket access. | File layout and format strongly affect performance. |
| Cloud Storage | Immutable raw and open-format persistence. | Durable, scalable, lifecycle controls. | Not a semantic product interface by itself. |
| Knowledge Catalog | Metadata, context, glossary, profiling, quality and lineage. | Enterprise discovery and AI context. | Coverage and scans require location and service validation. |
| Analytics Hub | Data product marketplace and managed sharing. | Clear producer-consumer model. | External sharing requires legal and security review. |
| Dataform | SQL product transformations and assertions. | Version-controlled BigQuery workflows. | Not a general-purpose orchestration engine. |
| Dataflow | Batch and streaming product pipelines. | Apache Beam portability and robust stream patterns. | Requires engineering standards for state, replay and cost. |
| IAM and policy tags | Access control. | Group-based access and column-level control. | Taxonomy governance and regional placement must be managed. |


## Architecture Decision Records

### MESH-ADR-001: Adopt federated data mesh instead of centralized-only data delivery

| Field | Content |
| --- | --- |
| Status | Proposed for enterprise adoption |
| Date | 2026-07-11 |
| Problem | Centralized data teams cannot scale product delivery across hundreds of domains. |
| Alternatives considered | Centralized platform only; decentralized marts; federated mesh. |
| Decision | Adopt federated mesh with central platform and domain ownership. |
| Tradeoffs | Requires stronger product ownership and governance automation. |
| Risks | Organizational adoption, inconsistent execution or control gaps if automation is incomplete. |
| Mitigations | Executive sponsorship, domain KPIs and automated controls. |
| Review trigger | Annual review or material change to Google Cloud capabilities, regulation or enterprise operating model. |

### MESH-ADR-002: Use domain-owned data products as the primary delivery unit

| Field | Content |
| --- | --- |
| Status | Proposed for enterprise adoption |
| Date | 2026-07-11 |
| Problem | Datasets without product commitments are hard to trust or reuse. |
| Alternatives considered | Dataset ownership; report ownership; product ownership. |
| Decision | Certified data products become the standard unit of enterprise data consumption. |
| Tradeoffs | Adds metadata and SLO obligations. |
| Risks | Organizational adoption, inconsistent execution or control gaps if automation is incomplete. |
| Mitigations | Self-service templates and maturity-based adoption. |
| Review trigger | Annual review or material change to Google Cloud capabilities, regulation or enterprise operating model. |

### MESH-ADR-003: Use Knowledge Catalog as enterprise metadata and discovery plane

| Field | Content |
| --- | --- |
| Status | Proposed for enterprise adoption |
| Date | 2026-07-11 |
| Problem | Consumers need a single context layer for products and governance. |
| Alternatives considered | Spreadsheet inventory; third-party catalog; Knowledge Catalog. |
| Decision | Use Knowledge Catalog as the Google Cloud-native catalog and governance context layer. |
| Tradeoffs | Requires integration and completeness discipline. |
| Risks | Organizational adoption, inconsistent execution or control gaps if automation is incomplete. |
| Mitigations | CI/CD metadata sync and certification gates. |
| Review trigger | Annual review or material change to Google Cloud capabilities, regulation or enterprise operating model. |

### MESH-ADR-004: Use Analytics Hub for managed product sharing

| Field | Content |
| --- | --- |
| Status | Proposed for enterprise adoption |
| Date | 2026-07-11 |
| Problem | Consumers need auditable subscription patterns. |
| Alternatives considered | Direct dataset IAM; manual copies; Analytics Hub listings. |
| Decision | Publish certified products through exchanges and listings where appropriate. |
| Tradeoffs | Requires marketplace operating model. |
| Risks | Organizational adoption, inconsistent execution or control gaps if automation is incomplete. |
| Mitigations | Define exchange types and publication standards. |
| Review trigger | Annual review or material change to Google Cloud capabilities, regulation or enterprise operating model. |

### MESH-ADR-005: Use BigQuery and BigLake as standard product interfaces

| Field | Content |
| --- | --- |
| Status | Proposed for enterprise adoption |
| Date | 2026-07-11 |
| Problem | Products must support warehouse and lakehouse patterns. |
| Alternatives considered | BigQuery only; object storage only; mixed unmanaged interfaces. |
| Decision | Use BigQuery for curated products and BigLake for governed open-format products. |
| Tradeoffs | Requires file layout standards for BigLake. |
| Risks | Organizational adoption, inconsistent execution or control gaps if automation is incomplete. |
| Mitigations | Define product interface selection matrix. |
| Review trigger | Annual review or material change to Google Cloud capabilities, regulation or enterprise operating model. |

### MESH-ADR-006: Mandate data contracts for certified products

| Field | Content |
| --- | --- |
| Status | Proposed for enterprise adoption |
| Date | 2026-07-11 |
| Problem | Consumers need predictable schema, semantics and freshness. |
| Alternatives considered | Informal documentation; schema-only contracts; full contracts. |
| Decision | Full contracts are mandatory for certification. |
| Tradeoffs | Increases initial product effort. |
| Risks | Organizational adoption, inconsistent execution or control gaps if automation is incomplete. |
| Mitigations | Provide contract templates and CI validation. |
| Review trigger | Annual review or material change to Google Cloud capabilities, regulation or enterprise operating model. |

### MESH-ADR-007: Use policy tags, row policies and masking for sensitive products

| Field | Content |
| --- | --- |
| Status | Proposed for enterprise adoption |
| Date | 2026-07-11 |
| Problem | Sensitive products need fine-grained controls. |
| Alternatives considered | Dataset-only IAM; copies with masked data; fine-grained policies. |
| Decision | Use fine-grained policies plus authorized interfaces. |
| Tradeoffs | Requires taxonomy governance. |
| Risks | Organizational adoption, inconsistent execution or control gaps if automation is incomplete. |
| Mitigations | Automated classification and schema validation. |
| Review trigger | Annual review or material change to Google Cloud capabilities, regulation or enterprise operating model. |

### MESH-ADR-008: Require product-level SLOs and observability

| Field | Content |
| --- | --- |
| Status | Proposed for enterprise adoption |
| Date | 2026-07-11 |
| Problem | Product trust depends on measurable operations. |
| Alternatives considered | Best effort; platform-only SLO; product SLO. |
| Decision | Each certified product has freshness, quality and availability SLOs. |
| Tradeoffs | Requires monitoring cost and ownership. |
| Risks | Organizational adoption, inconsistent execution or control gaps if automation is incomplete. |
| Mitigations | Generate default dashboards from templates. |
| Review trigger | Annual review or material change to Google Cloud capabilities, regulation or enterprise operating model. |

### MESH-ADR-009: Adopt domain project factory patterns

| Field | Content |
| --- | --- |
| Status | Proposed for enterprise adoption |
| Date | 2026-07-11 |
| Problem | Domain autonomy needs repeatable infrastructure. |
| Alternatives considered | Manual projects; central shared project; project factory. |
| Decision | Provision standardized projects and datasets through Terraform. |
| Tradeoffs | Initial module investment. |
| Risks | Organizational adoption, inconsistent execution or control gaps if automation is incomplete. |
| Mitigations | Reusable modules and onboarding checklist. |
| Review trigger | Annual review or material change to Google Cloud capabilities, regulation or enterprise operating model. |

### MESH-ADR-010: Use group-based access and avoid direct user grants

| Field | Content |
| --- | --- |
| Status | Proposed for enterprise adoption |
| Date | 2026-07-11 |
| Problem | Auditability and lifecycle require group-based control. |
| Alternatives considered | User grants; group grants; dynamic access service. |
| Decision | Use groups and product-specific bindings by default. |
| Tradeoffs | Group lifecycle must be managed. |
| Risks | Organizational adoption, inconsistent execution or control gaps if automation is incomplete. |
| Mitigations | Recertification and access expiry. |
| Review trigger | Annual review or material change to Google Cloud capabilities, regulation or enterprise operating model. |

### MESH-ADR-011: Implement certification before marketplace publication

| Field | Content |
| --- | --- |
| Status | Proposed for enterprise adoption |
| Date | 2026-07-11 |
| Problem | Marketplace without trust signals creates risk. |
| Alternatives considered | Open publication; manual review only; automated certification gate. |
| Decision | Products must pass certification gates before enterprise publication. |
| Tradeoffs | Could slow early adoption. |
| Risks | Organizational adoption, inconsistent execution or control gaps if automation is incomplete. |
| Mitigations | Define pilot maturity exceptions. |
| Review trigger | Annual review or material change to Google Cloud capabilities, regulation or enterprise operating model. |

### MESH-ADR-012: Treat AI-ready products as a stricter certification class

| Field | Content |
| --- | --- |
| Status | Proposed for enterprise adoption |
| Date | 2026-07-11 |
| Problem | AI use increases privacy and misuse risk. |
| Alternatives considered | Allow all certified products for AI; block AI; AI certification class. |
| Decision | Create AI-ready certification with allowed-use and guardrails. |
| Tradeoffs | More governance work. |
| Risks | Organizational adoption, inconsistent execution or control gaps if automation is incomplete. |
| Mitigations | Templates and AI review checklist. |
| Review trigger | Annual review or material change to Google Cloud capabilities, regulation or enterprise operating model. |

### MESH-ADR-013: Use chargeback/showback at product and domain level

| Field | Content |
| --- | --- |
| Status | Proposed for enterprise adoption |
| Date | 2026-07-11 |
| Problem | Cost transparency is required for mesh sustainability. |
| Alternatives considered | Project-only cost; domain cost; product cost. |
| Decision | Use product labels and billing export for product-level showback and targeted chargeback. |
| Tradeoffs | Attribution is imperfect for shared workloads. |
| Risks | Organizational adoption, inconsistent execution or control gaps if automation is incomplete. |
| Mitigations | Improve labels and query job tagging. |
| Review trigger | Annual review or material change to Google Cloud capabilities, regulation or enterprise operating model. |

### MESH-ADR-014: Use versioned deprecation instead of breaking product changes

| Field | Content |
| --- | --- |
| Status | Proposed for enterprise adoption |
| Date | 2026-07-11 |
| Problem | Consumers need stability. |
| Alternatives considered | Immediate breaking changes; endless old versions; planned deprecation. |
| Decision | Breaking changes require major version and migration window. |
| Tradeoffs | Maintains multiple versions temporarily. |
| Risks | Organizational adoption, inconsistent execution or control gaps if automation is incomplete. |
| Mitigations | Usage monitoring and retirement gates. |
| Review trigger | Annual review or material change to Google Cloud capabilities, regulation or enterprise operating model. |

### MESH-ADR-015: Use domain stewards as certification evidence owners

| Field | Content |
| --- | --- |
| Status | Proposed for enterprise adoption |
| Date | 2026-07-11 |
| Problem | Business meaning cannot be delegated entirely to engineers. |
| Alternatives considered | Engineer-only review; governance-only review; steward-owned evidence. |
| Decision | Data stewards own business metadata and quality interpretation. |
| Tradeoffs | Requires staffing. |
| Risks | Organizational adoption, inconsistent execution or control gaps if automation is incomplete. |
| Mitigations | Steward enablement and governance workflows. |
| Review trigger | Annual review or material change to Google Cloud capabilities, regulation or enterprise operating model. |



## Risks and Mitigations

| Risk | Impact | Mitigation |
| --- | --- | --- |
| Domains do not accept ownership | Mesh becomes a catalog of central-team datasets. | Tie ownership to executive KPIs, product funding and certification gates. |
| Governance becomes manual bottleneck | Product delivery slows and teams bypass controls. | Automate policy checks and delegate low-risk approvals. |
| Inconsistent product semantics | Consumers lose trust and duplicate datasets. | Use glossary, steward review and product contracts. |
| Sensitive data is overexposed | Regulatory and reputational impact. | Classification, policy tags, masking, approvals and audit. |
| Product cost sprawl | FinOps objectives fail. | Product labels, budgets, query standards and chargeback. |
| Marketplace fills with low-quality products | Discovery quality collapses. | Certification levels and deprecation discipline. |
| Breaking changes disrupt consumers | Operational and reporting failures. | Versioning, compatibility checks and migration windows. |
| AI use misapplies data | Privacy or model-risk incidents. | AI-ready certification and allowed-use metadata. |


## Implementation Roadmap

| Phase | Duration | Key outcomes |
| --- | --- | --- |
| 0. Mobilize | 4-6 weeks | Approve operating model, domains, standards and first pilot products. |
| 1. Foundation | 6-10 weeks | Deploy product templates, catalog integration, quality framework and access workflow. |
| 2. Pilot domains | 10-16 weeks | Publish first certified products in Customer/Finance or similar high-value domains. |
| 3. Scale domains | 3-6 months | Onboard additional domains and exchange patterns. |
| 4. Optimize | 6-12 months | Product cost optimization, reuse metrics, AI-ready products and automated governance. |
| 5. Institutionalize | Ongoing | Quarterly product reviews, maturity assessments and continuous platform improvements. |
| Milestone | Acceptance evidence |
| --- | --- |
| First certified product | Contract, catalog entry, quality scorecard, access workflow and dashboard. |
| First Analytics Hub listing | Exchange, listing, subscription workflow and audit evidence. |
| First restricted product | Policy tags, masking, row policies and approval workflow. |
| First cross-domain product | Documented upstream dependency and SLO. |
| First AI-ready product | Allowed-use statement, classification and AI review evidence. |


## Data Mesh Validation Checklist

| Validation item | Pass criteria |
| --- | --- |
| Ownership | Every certified product has owner, steward and support route. |
| Contract | Contract validates through CI/CD. |
| Security | Sensitive fields classified and protected. |
| Quality | Critical rules are automated and monitored. |
| Lineage | Upstream sources and downstream consumers documented. |
| Marketplace | Published product includes metadata, usage terms and access workflow. |
| SLO | Freshness, availability and correctness are measurable. |
| Cost | Product spend is visible in FinOps dashboard. |
| Operations | Runbook and incident process are available. |
| Deprecation | Versioning and retirement process exists before publication. |


## Appendices and Reference Implementations

The package includes Terraform, BigQuery SQL, Dataform SQLX, diagram sources and workshop checklists. These
are reference implementations and must be adapted to organization-specific billing accounts, folders, regions,
IAM groups, VPC Service Controls, policy tags and naming conventions.

| Artifact | Location | Purpose |
| --- | --- | --- |
| Domain Terraform module | terraform/domain_module.tf | Reusable domain project and dataset example. |
| Analytics Hub Terraform | terraform/analytics_hub_listing.tf | Data marketplace listing example. |
| BigQuery DDL | sql/data_product_ddl.sql | Certified product table pattern. |
| Dataform SQLX | dataform/customer_360.sqlx | Incremental product build example with assertions. |
| Workshop checklist | workshops/data_mesh_design_review_checklist.md | Review guide for domain product design. |
| Diagrams | diagrams/* | Graphviz, Mermaid, PlantUML, Draw.io, SVG and PNG diagrams. |

## References

- Google Cloud Architecture Center - Architecture and functions in a data mesh: https://docs.cloud.google.com/architecture/data-mesh
- Google Cloud Architecture Center - Build data products in a data mesh: https://docs.cloud.google.com/architecture/build-data-products-data-mesh
- Google Cloud Knowledge Catalog overview: https://docs.cloud.google.com/dataplex/docs/introduction
- Knowledge Catalog data profiling: https://docs.cloud.google.com/dataplex/docs/data-profiling-overview
- Knowledge Catalog data quality scans: https://docs.cloud.google.com/dataplex/docs/auto-data-quality-overview
- Knowledge Catalog data lineage: https://docs.cloud.google.com/dataplex/docs/about-data-lineage
- BigQuery row-level security: https://docs.cloud.google.com/bigquery/docs/row-level-security-intro
- BigQuery column-level security: https://docs.cloud.google.com/bigquery/docs/column-level-security-intro
- BigQuery dynamic data masking: https://docs.cloud.google.com/bigquery/docs/column-data-masking-intro
- BigQuery policy tags best practices: https://docs.cloud.google.com/bigquery/docs/best-practices-policy-tags



# Detailed Data Mesh Implementation Guide

This section expands the core architecture into an implementation guide that domain product teams, platform
engineers, governance reviewers and security architects can use during design and delivery. It converts the
operating model into concrete artefacts, lifecycle gates, role assignments, metadata standards, contract
content, product templates, controls, acceptance tests and review cadences. The intent is to remove ambiguity:
a team should know when a dataset is not yet a product, when a product is not yet certifiable, and when a
published product must be remediated, versioned or retired.

## End-to-End Operating Process

| Operating step | Implementation detail |
| --- | --- |
| Demand qualification | The product manager captures the consumer problem, expected decisions, regulatory sensitivity, target consumers, existing duplicate products, estimated value, expected frequency, consumer latency requirements and criticality. This prevents the mesh from filling with products that nobody consumes or products that duplicate existing certified assets. |
| Domain approval | The domain data owner confirms that the candidate product belongs in the domain, has a funding path, and has an accountable product team. If ownership is unclear, the governance council resolves domain placement before engineering begins. |
| Contract-first design | The team writes the contract before implementation. The contract defines grain, fields, semantic definitions, security classification, freshness, quality rules, compatibility policy and support model. Contract-first delivery prevents pipelines from shaping product semantics by accident. |
| Security and privacy design | Restricted fields, policy tags, masking, row filters, authorized views, allowed-use statements, residency rules and access workflow requirements are defined during design. Security is not deferred to the publication phase. |
| Build and test | The product is implemented using approved pipeline templates. Dataform assertions, schema tests, reconciliation tests, policy checks and unit tests run in development and test environments. Changes are reviewed through pull requests and deployed through CI/CD. |
| Certification review | The steward, owner, platform reviewer and security reviewer evaluate evidence. The product is certified only when mandatory controls pass or a time-bound exception is recorded. |
| Publication and onboarding | The product is published into the marketplace, consumers are onboarded through the access workflow, examples are provided, and usage tracking begins. |
| Operate and improve | The team monitors SLOs, quality, incidents, cost, consumer feedback and adoption. The product roadmap is adjusted based on measurable value, not only producer priorities. |

## Standard Data Product Template

The following template is mandatory for every certified product. It may be implemented as YAML, JSON,
repository metadata, catalog metadata or a combination of these, but the content must remain consistent across
the repository, catalog and marketplace listing.

| Template section | Mandatory fields | Example |
| --- | --- | --- |
| Identity | product_id, display_name, domain, version, status, tier, owner, steward, support_group | customer.customer_360.v1 |
| Business context | purpose, business process, consumers, decisions supported, limitations, allowed use | Used for service segmentation and care planning; not approved for credit decisions. |
| Semantics | grain, glossary_terms, entity definitions, metric definitions, reference data dependencies | One row per active customer profile per effective timestamp. |
| Interface | interface_type, dataset, table/view/listing, API endpoint, event topic, sample queries | BigQuery table with Analytics Hub listing and authorized regional views. |
| Schema | field name, type, mode, description, sensitivity, policy tag, nullability, example | customer_id STRING REQUIRED, Confidential, policy tag: pii_identifier. |
| Quality | rules, thresholds, severity, owner, remediation path, exception process | customer_id non-null 100%; region_code reference-valid 99.9%. |
| SLO | freshness, availability, support response, incident severity, business calendar | 95% refreshed within 15 minutes during business day. |
| Security | classification, access pattern, masking, row filters, export restriction, approval requirements | Restricted PII, masked for standard analysts, direct access prohibited. |
| Lifecycle | release policy, compatibility, deprecation window, retirement criteria | Minor versions compatible; major versions require 180-day migration window. |
| FinOps | cost center, labels, consumer attribution, chargeback rule, budget owner | business_domain=customer; product=customer_360; showback monthly. |
| Operations | dashboard URL, runbook URL, escalation, incident queue, maintenance window | ServiceNow queue DATA-CUST-PROD; 24x5 support. |

## Detailed RACI Matrix

| Activity | Governance Council | Domain Owner | Data Steward | Product Manager | Product Engineer | Platform Team | Security | FinOps | Consumer |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Approve product candidacy | C | A | R | R | I | I | C | C | C |
| Define business terms | A | A | R | C | I | I | C | I | C |
| Define product contract | C | A | R | R | C | C | C | C | C |
| Build pipeline and table | I | I | C | C | R | C | I | I | I |
| Define security controls | C | A | C | C | I | C | R | I | I |
| Approve restricted access | I | A | C | I | I | I | R | I | C |
| Publish marketplace listing | C | A | R | R | C | R | C | I | I |
| Monitor SLOs | I | A | C | R | R | C | C | C | I |
| Remediate quality issue | I | A | R | C | R | C | I | I | C |
| Review product cost | I | A | I | R | C | C | I | R | C |
| Deprecate product | C | A | R | R | C | C | C | C | C |
| Approve exception | A | R | C | C | I | C | R | C | I |

## Data Product Taxonomy

| Product type | Definition and design implication |
| --- | --- |
| Source-aligned product | A domain-owned product that exposes cleaned, documented and access-controlled data close to the source semantics. It is useful for teams that need detail and for building downstream products. It is not a raw dump; it includes schema, quality and lineage commitments. |
| Aggregate product | A product that combines several source-aligned products within one domain to answer recurring business questions. It usually has a more stable semantic model and narrower grain. |
| Consumer-aligned product | A product optimized for a particular consumer group or business process, such as finance close, demand planning or care-management operations. These products should avoid hard-coding one report when a reusable semantic product is possible. |
| Reference product | A stable set of enterprise reference values, hierarchies or mappings. It has stricter change control because many domains may depend on it. |
| Master-data product | A governed representation of core entities such as customer, product, supplier or employee. These products need explicit survivorship rules and stewardship. |
| Event product | A versioned event stream representing business changes, such as order created, shipment delayed or consent changed. It requires schema versioning, ordering and replay considerations. |
| AI-ready product | A certified product with additional metadata, allowed-use statements, sensitive-data controls and evaluation requirements for ML, RAG or agentic use cases. |
| External-sharing product | A product intended for partner, regulator or third-party consumption. It requires legal terms, minimization, residency and stronger audit evidence. |

## Domain Decomposition Workshop Outputs

Each domain decomposition workshop should produce artefacts that can be reviewed by architecture, governance
and platform teams. These artefacts prevent disagreement later about ownership, scope and product priority.

| Workshop artefact | Description | Review question |
| --- | --- | --- |
| Capability map | Business capabilities grouped into candidate domains. | Does each candidate domain have a stable business owner? |
| Entity map | Core entities, identifiers and authoritative systems. | Which domain owns the meaning and lifecycle of each entity? |
| Source map | Applications, databases, SaaS platforms, files and streams feeding the domain. | Are sources grouped by semantics rather than platform convenience? |
| Consumer map | Teams, reports, applications, AI use cases and partners that need products. | Which consumers need certified products first? |
| Regulatory map | Sensitive data, residency, retention and legal constraints. | Which products require restricted design patterns? |
| Quality pain-point map | Known defects, reconciliation issues and source inconsistencies. | Which defects block certification and need remediation funding? |
| Product backlog | Prioritized candidate products with value and complexity. | Which first product proves the domain pattern end-to-end? |
| Dependency map | Upstream and downstream product dependencies. | Which cross-domain contracts must be negotiated? |

## Metadata and Catalog Standards

Metadata standards are the difference between a mesh that is discoverable and one that merely has many
datasets. Each certified product must maintain metadata in four layers: technical metadata, business metadata,
operational metadata and governance metadata. Automation should extract what systems know and require humans
to add what only the business knows.

| Metadata layer | Required fields | Source of truth |
| --- | --- | --- |
| Technical | dataset, table, view, schema, partitioning, clustering, lineage, pipeline, code repository | Deployment metadata and Google Cloud asset metadata. |
| Business | description, business terms, grain, owner, steward, intended use, limitations | Contract repository and steward input. |
| Operational | freshness, quality score, incident history, SLO status, usage, downstream consumers | Monitoring, quality scans, logs and job metadata. |
| Governance | classification, policy tags, access rules, retention, legal hold, privacy deletion, certification status | Governance policy repository and catalog entries. |

| Catalog completeness criterion | Minimum standard for certification |
| --- | --- |
| Name and description | Human-readable product name and decision-oriented description. |
| Owner and steward | Named individuals or groups with support channel. |
| Classification | Product and field-level sensitivity recorded. |
| Glossary links | At least core business terms linked to enterprise glossary. |
| Quality status | Current quality score and rule summary visible. |
| Freshness status | Last update and SLO status visible. |
| Lineage | Upstream sources and downstream dependencies captured or documented. |
| Access instructions | Consumer request process, approval requirements and usage obligations. |
| Examples | At least one safe sample query or access example. |
| Lifecycle status | Candidate, certified, deprecated or retired. |

## Data Mesh Metrics and KPIs

A data mesh must be measured as a product portfolio. Adoption alone is insufficient because broad use of low-
quality data can increase enterprise risk. The portfolio dashboard should show value, trust, security,
efficiency and operational health.

| KPI category | Metric | Why it matters |
| --- | --- | --- |
| Adoption | Active consumers per product | Shows reuse and product-market fit. |
| Reuse | Duplicate curated datasets retired | Measures whether the mesh reduces fragmentation. |
| Trust | Certified products as percentage of active products | Shows governance maturity. |
| Quality | Average critical rule pass rate | Indicates consumer reliability. |
| Freshness | Percentage of products meeting freshness SLO | Shows operational health. |
| Security | Restricted products with complete policy evidence | Measures security compliance. |
| Cost | Cost per certified product and cost per active consumer | Shows efficiency and chargeback readiness. |
| Lifecycle | Products deprecated or retired on schedule | Prevents stale marketplace assets. |
| Speed | Lead time from product approval to publication | Measures self-service platform effectiveness. |
| AI readiness | Products certified for AI use | Shows readiness for governed AI adoption. |

## Control Mapping for Regulated Data Products

| Control objective | Mesh implementation | Evidence |
| --- | --- | --- |
| Purpose limitation | Allowed-use statement in product contract and access request. | Contract and workflow record. |
| Least privilege | Groups, authorized views, row filters and policy tags. | IAM export and policy configuration. |
| Data minimization | Consumer interface exposes only approved attributes. | View definition and approval record. |
| Access review | Periodic recertification for sensitive products. | Access review report. |
| Auditability | Query, access and publication logs retained. | Cloud Audit Logs and BigQuery audit views. |
| Retention | Retention policy defined at product and source layer. | Dataset/table/bucket policy evidence. |
| Privacy deletion | Deletion or suppression process defined for applicable entities. | Runbook and execution logs. |
| Legal hold | Products subject to hold cannot be deleted or modified outside policy. | Hold record and exception log. |
| Change control | Versioned contracts and CI/CD approvals. | Pull requests and deployment logs. |
| Incident response | Product runbook and escalation route. | Runbook and incident tickets. |

## Expanded Domain Product Catalogs

### Healthcare Product Catalog

| Product | Description | Classification | Primary sources | Consumers |
| --- | --- | --- | --- | --- |
| Patient 360 | One row per patient profile with identifiers, demographics, consent, care-team and risk flags. | PHI restricted | FHIR, EHR master patient index, consent platform | Clinical analytics, care management |
| Encounter Summary | Encounter-level clinical and administrative events. | PHI restricted | EHR, HL7/FHIR feeds | Operations, quality, regulatory |
| Claims Analytics | Claim header, line, adjudication and payment facts. | PHI and financial restricted | Claims platform, payer feeds | Finance, risk, actuarial |
| Care Gap Registry | Preventive and chronic-care gap status by patient. | PHI restricted | EHR, quality rules, reference guidelines | Population health |
| Provider Network | Provider, facility and network participation data. | Confidential | Provider directory, credentialing | Access planning, network analytics |

| Product | Minimum quality gates | Standard SLO |
| --- | --- | --- |
| Patient 360 | Primary key uniqueness; freshness check; classification check; contract compatibility; reconciliation where applicable. | Tier based on criticality: 15 minutes to 24 hours freshness; 99.5%-99.9% availability. |
| Encounter Summary | Primary key uniqueness; freshness check; classification check; contract compatibility; reconciliation where applicable. | Tier based on criticality: 15 minutes to 24 hours freshness; 99.5%-99.9% availability. |
| Claims Analytics | Primary key uniqueness; freshness check; classification check; contract compatibility; reconciliation where applicable. | Tier based on criticality: 15 minutes to 24 hours freshness; 99.5%-99.9% availability. |
| Care Gap Registry | Primary key uniqueness; freshness check; classification check; contract compatibility; reconciliation where applicable. | Tier based on criticality: 15 minutes to 24 hours freshness; 99.5%-99.9% availability. |
| Provider Network | Primary key uniqueness; freshness check; classification check; contract compatibility; reconciliation where applicable. | Tier based on criticality: 15 minutes to 24 hours freshness; 99.5%-99.9% availability. |

### Finance Product Catalog

| Product | Description | Classification | Primary sources | Consumers |
| --- | --- | --- | --- | --- |
| General Ledger Gold | Certified account balances and journal facts by legal entity and period. | Confidential/restricted | ERP GL, subledger | Close, audit, reporting |
| Profitability Cube | Revenue, cost and margin by product, customer and region. | Confidential | GL, sales, product, allocations | FP&A, executives |
| Treasury Liquidity | Cash position, forecast and bank account summaries. | Restricted | Treasury systems, bank feeds | Treasury |
| Tax Reporting Pack | Tax-relevant transactions and jurisdiction attributes. | Restricted | ERP, billing, procurement | Tax and compliance |
| Vendor Spend | Supplier and purchase spend with categories. | Confidential | Procurement, AP | Procurement, finance |

| Product | Minimum quality gates | Standard SLO |
| --- | --- | --- |
| General Ledger Gold | Primary key uniqueness; freshness check; classification check; contract compatibility; reconciliation where applicable. | Tier based on criticality: 15 minutes to 24 hours freshness; 99.5%-99.9% availability. |
| Profitability Cube | Primary key uniqueness; freshness check; classification check; contract compatibility; reconciliation where applicable. | Tier based on criticality: 15 minutes to 24 hours freshness; 99.5%-99.9% availability. |
| Treasury Liquidity | Primary key uniqueness; freshness check; classification check; contract compatibility; reconciliation where applicable. | Tier based on criticality: 15 minutes to 24 hours freshness; 99.5%-99.9% availability. |
| Tax Reporting Pack | Primary key uniqueness; freshness check; classification check; contract compatibility; reconciliation where applicable. | Tier based on criticality: 15 minutes to 24 hours freshness; 99.5%-99.9% availability. |
| Vendor Spend | Primary key uniqueness; freshness check; classification check; contract compatibility; reconciliation where applicable. | Tier based on criticality: 15 minutes to 24 hours freshness; 99.5%-99.9% availability. |

### Human Resources Product Catalog

| Product | Description | Classification | Primary sources | Consumers |
| --- | --- | --- | --- | --- |
| Workforce Headcount | Current and historical worker population and status. | Restricted employee data | Workday, identity | Workforce planning |
| Organization Hierarchy | Manager and organization relationships. | Confidential/restricted | HRIS, identity | Planning, access governance |
| Skills Inventory | Skills, certifications and learning completions. | Confidential | Learning systems, HRIS | Talent planning |
| Attrition Analytics | Employee movement and attrition features. | Restricted | HRIS, performance, engagement | HR analytics |
| Payroll Controls | Payroll reconciliation and control totals. | Restricted | Payroll, finance | Payroll operations, audit |

| Product | Minimum quality gates | Standard SLO |
| --- | --- | --- |
| Workforce Headcount | Primary key uniqueness; freshness check; classification check; contract compatibility; reconciliation where applicable. | Tier based on criticality: 15 minutes to 24 hours freshness; 99.5%-99.9% availability. |
| Organization Hierarchy | Primary key uniqueness; freshness check; classification check; contract compatibility; reconciliation where applicable. | Tier based on criticality: 15 minutes to 24 hours freshness; 99.5%-99.9% availability. |
| Skills Inventory | Primary key uniqueness; freshness check; classification check; contract compatibility; reconciliation where applicable. | Tier based on criticality: 15 minutes to 24 hours freshness; 99.5%-99.9% availability. |
| Attrition Analytics | Primary key uniqueness; freshness check; classification check; contract compatibility; reconciliation where applicable. | Tier based on criticality: 15 minutes to 24 hours freshness; 99.5%-99.9% availability. |
| Payroll Controls | Primary key uniqueness; freshness check; classification check; contract compatibility; reconciliation where applicable. | Tier based on criticality: 15 minutes to 24 hours freshness; 99.5%-99.9% availability. |

### Sales Product Catalog

| Product | Description | Classification | Primary sources | Consumers |
| --- | --- | --- | --- | --- |
| Pipeline Forecast | Open opportunities, stages and forecast categories. | Confidential | CRM, forecast tools | Sales ops, executives |
| Account 360 | Account hierarchy, activity, revenue and risk. | Confidential | CRM, billing, support | Sales, success |
| Bookings Gold | Certified bookings and order facts. | Confidential | CRM, CPQ, order management | Finance, revenue ops |
| Territory Assignment | Seller, account and territory coverage. | Confidential | Territory tools, CRM | Sales ops |
| Partner Performance | Partner pipeline, bookings and enablement indicators. | Confidential | Partner portal, CRM | Channel operations |

| Product | Minimum quality gates | Standard SLO |
| --- | --- | --- |
| Pipeline Forecast | Primary key uniqueness; freshness check; classification check; contract compatibility; reconciliation where applicable. | Tier based on criticality: 15 minutes to 24 hours freshness; 99.5%-99.9% availability. |
| Account 360 | Primary key uniqueness; freshness check; classification check; contract compatibility; reconciliation where applicable. | Tier based on criticality: 15 minutes to 24 hours freshness; 99.5%-99.9% availability. |
| Bookings Gold | Primary key uniqueness; freshness check; classification check; contract compatibility; reconciliation where applicable. | Tier based on criticality: 15 minutes to 24 hours freshness; 99.5%-99.9% availability. |
| Territory Assignment | Primary key uniqueness; freshness check; classification check; contract compatibility; reconciliation where applicable. | Tier based on criticality: 15 minutes to 24 hours freshness; 99.5%-99.9% availability. |
| Partner Performance | Primary key uniqueness; freshness check; classification check; contract compatibility; reconciliation where applicable. | Tier based on criticality: 15 minutes to 24 hours freshness; 99.5%-99.9% availability. |

### Marketing Product Catalog

| Product | Description | Classification | Primary sources | Consumers |
| --- | --- | --- | --- | --- |
| Campaign Performance | Campaign spend, engagement, conversion and ROI metrics. | Confidential | Marketing automation, ad platforms | Marketing analytics |
| Consent Status | Current consent and communication preferences. | Restricted PII | Consent platform, CRM | Marketing, privacy, sales |
| Audience Segments | Approved analytical and activation segments. | Restricted when identifiable | CDP, web analytics, CRM | Activation, analytics |
| Attribution Model | Multi-touch attribution metrics. | Confidential | Web analytics, CRM, campaign data | Marketing analytics |
| Lead Funnel | Lead lifecycle and conversion facts. | Confidential | Marketing automation, CRM | Marketing and sales ops |

| Product | Minimum quality gates | Standard SLO |
| --- | --- | --- |
| Campaign Performance | Primary key uniqueness; freshness check; classification check; contract compatibility; reconciliation where applicable. | Tier based on criticality: 15 minutes to 24 hours freshness; 99.5%-99.9% availability. |
| Consent Status | Primary key uniqueness; freshness check; classification check; contract compatibility; reconciliation where applicable. | Tier based on criticality: 15 minutes to 24 hours freshness; 99.5%-99.9% availability. |
| Audience Segments | Primary key uniqueness; freshness check; classification check; contract compatibility; reconciliation where applicable. | Tier based on criticality: 15 minutes to 24 hours freshness; 99.5%-99.9% availability. |
| Attribution Model | Primary key uniqueness; freshness check; classification check; contract compatibility; reconciliation where applicable. | Tier based on criticality: 15 minutes to 24 hours freshness; 99.5%-99.9% availability. |
| Lead Funnel | Primary key uniqueness; freshness check; classification check; contract compatibility; reconciliation where applicable. | Tier based on criticality: 15 minutes to 24 hours freshness; 99.5%-99.9% availability. |

### Supply Chain Product Catalog

| Product | Description | Classification | Primary sources | Consumers |
| --- | --- | --- | --- | --- |
| Inventory Position | SKU/location inventory, availability and movements. | Confidential | WMS, ERP, IoT | Operations, planning |
| Shipment Visibility | Shipment events, carrier status and delay predictions. | Confidential | TMS, carrier APIs, IoT | Logistics, customer service |
| Supplier Risk | Supplier performance, disruptions and risk indicators. | Confidential/restricted | Supplier portal, risk feeds | Procurement, resilience |
| Demand Forecast Inputs | Historical demand and external drivers for forecasting. | Confidential | Orders, sales, external signals | Planning, AI |
| Order Fulfillment | Order status, pick/pack/ship and exception metrics. | Confidential | OMS, WMS, TMS | Operations, sales |

| Product | Minimum quality gates | Standard SLO |
| --- | --- | --- |
| Inventory Position | Primary key uniqueness; freshness check; classification check; contract compatibility; reconciliation where applicable. | Tier based on criticality: 15 minutes to 24 hours freshness; 99.5%-99.9% availability. |
| Shipment Visibility | Primary key uniqueness; freshness check; classification check; contract compatibility; reconciliation where applicable. | Tier based on criticality: 15 minutes to 24 hours freshness; 99.5%-99.9% availability. |
| Supplier Risk | Primary key uniqueness; freshness check; classification check; contract compatibility; reconciliation where applicable. | Tier based on criticality: 15 minutes to 24 hours freshness; 99.5%-99.9% availability. |
| Demand Forecast Inputs | Primary key uniqueness; freshness check; classification check; contract compatibility; reconciliation where applicable. | Tier based on criticality: 15 minutes to 24 hours freshness; 99.5%-99.9% availability. |
| Order Fulfillment | Primary key uniqueness; freshness check; classification check; contract compatibility; reconciliation where applicable. | Tier based on criticality: 15 minutes to 24 hours freshness; 99.5%-99.9% availability. |

## Common Anti-Patterns and Corrective Actions

| Anti-pattern | Why it fails | Correction |
| --- | --- | --- |
| Every application becomes a domain | Creates technical silos instead of business ownership. | Decompose by business capability and semantic ownership. |
| Marketplace without certification | Consumers cannot determine what is trusted. | Use certification levels and quality evidence. |
| Raw data published as product | Consumers inherit source complexity and quality defects. | Require contract, quality, documentation and support. |
| Central team owns all products | Delivery becomes a bottleneck and semantics remain detached from business owners. | Shift ownership to domains with platform support. |
| Policy documents without automation | Controls are inconsistent and hard to audit. | Implement computational governance through CI/CD and metadata. |
| Broad access for convenience | Creates privacy and regulatory risk. | Use authorized views, policy tags, row filters and request workflows. |
| No deprecation process | Consumers break or continue using stale data. | Require versioning and retirement gates. |
| Cost ignored until late | Domain autonomy becomes cost sprawl. | Mandate product labels and cost dashboards from day one. |
| AI allowed by default | Sensitive data can be misused by models or agents. | Create AI-ready certification and explicit allowed-use metadata. |

## Review Agendas

| Review | Participants | Agenda |
| --- | --- | --- |
| Domain onboarding review | Domain owner, steward, platform, security, FinOps | Domain boundaries, sources, product backlog, project structure, classification and first pilot. |
| Product design review | Product manager, steward, engineers, security, consumers | Contract, interface, SLOs, access, quality rules, cost and lifecycle. |
| Certification review | Owner, steward, governance delegate, platform, security | Evidence, exceptions, quality, lineage, catalog and marketplace readiness. |
| Operational readiness review | Product team, SRE, platform, consumers | Dashboards, alerts, runbooks, escalation, recovery, cost and support. |
| Quarterly product review | Domain leadership, consumers, FinOps, governance | Usage, value, quality, cost, incidents, roadmap and retirement candidates. |

## Production Acceptance Criteria

| Category | Acceptance criterion |
| --- | --- |
| Architecture | Product aligns to approved domain and interface pattern. |
| Security | Classification, policy tags, row policies, masking and access workflow are configured as required. |
| Governance | Contract, catalog entry, owner, steward and glossary mapping are complete. |
| Quality | Critical rules pass and scorecard is visible. |
| Reliability | Freshness and availability monitoring exists. |
| Operations | Runbook, escalation and incident severity mapping exist. |
| FinOps | Labels, cost center and dashboard are available. |
| Marketplace | Listing or access documentation is complete. |
| Consumer adoption | At least one named consumer has validated the product. |
| Lifecycle | Versioning and deprecation policy is documented. |

