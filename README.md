# Microsoft-Fabric-Project

The repository is organized into different sections to guide you through the solution, from the original data sources to the final analytical model.

## 🔌 Data Sources
Explore the different source systems, their ingestion methods, raw datasets and associated scripts used in the project..

| Data Source | Architecture & Ingestion Overview | Raw Data Files | Additional Resources |
| :--- | :--- | :--- | :--- |
| **ADLS Gen2** | [ADLS2 Source Overview](docs/Data%20Sources/ADLS2/ADLS2_source.md) | [Raw Data Folder](docs/Data%20Sources/ADLS2/ADLS2_raw_data) | - |
| **GitHub Repository** | [GitHub Source Overview](docs/Data%20Sources/GITHUB/GITHUB_source.md) | [Source Data Repository](globalretail-source-data) | - |
| **SQL Server (OLTP)** | [SQL Server Source Overview](docs/Data%20Sources/SQL%20SERVER/SQL_SERVER_source.md) | [Raw Data Folder](docs/Data%20Sources/SQL%20SERVER/SQL_SERVER_raw_data) | [SQL Setup Scripts](docs/Data%20Sources/SQL%20SERVER/scripts) |

---

## 🏗️ Architecture & Data Layers

Follow the data journey through the Fabric architecture, from raw ingestion to the final business-ready model.

* [01. Architecture Overview](docs/Architecture/01.%20architecture_overview.md) : Overall architecture, data flow, Fabric components and design principles.
* [02. Naming Conventions](docs/Architecture/02.%20naming_conventions.md) : Naming standards adopted across the Fabric workspace.
* [03. Bronze Layer](docs/Architecture/03.%20bronze_layer.md) : Raw data ingestion and metadata-driven ingestion process.
* [04. Silver Layer](docs/Architecture/04.%20silver_layer.md) : Data cleansing, transformation, standardization and quality checks.
* [05. Gold Layer](docs/Architecture/05.%20gold_layer.md) : Business-ready data model, star schema, and analytical layer.
* [06. Orchestration & Lineage](docs/Architecture/06.%20orchestration%20&%20lineage.md) : End-to-end execution pipeline and data lineage flow.

```text
Microsoft-Fabric-Project/
├── .gitattributes
├── LICENSE
├── README.md
│
├── docs/
│   ├── Architecture/
│   │   ├── 01. architecture_overview.md
│   │   ├── 02. naming_conventions.md
│   │   ├── 03. bronze_layer.md
│   │   ├── 04. silver_layer.md
│   │   ├── 05. gold_layer.md
│   │   └── 06. orchestration & lineage.md
│   │
│   ├── Data Sources/
│   │   ├── ADLS2/
│   │   │   ├── ADLS2_raw_data/
│   │   │   │   ├── customers.csv
│   │   │   │   ├── inventory.csv
│   │   │   │   ├── legacy_customers.csv
│   │   │   │   ├── products.csv
│   │   │   │   └── suppliers.csv
│   │   │   └── ADLS2_source.md
│   │   │
│   │   ├── GITHUB/
│   │   │   └── GITHUB_source.md
│   │   │
│   │   └── SQL SERVER/
│   │       ├── SQL_SERVER_raw_data/
│   │       │   ├── order_campaign.csv
│   │       │   ├── order_details.csv
│   │       │   ├── orders.csv
│   │       │   └── reviews.json
│   │       ├── scripts/
│   │       │   ├── 01_script_create_tables_SSMS.sql
│   │       │   ├── 02_script_insert_bulk.sql
│   │       │   ├── 03_set_index_tables.sql
│   │       │   └── 04_script_constraints_&_business_rules_tables.sql
│   │       └── SQL_SERVER_source.md
│   │
│   └── Images/
│       ├── architecture/
│       │   └── GlobalRetail_Architecture_high_level.svg
│       ├── bronze/
│       ├── silver/
│       ├── gold/
│       └── orchestration/
│
├── fabric_workspace/
│   ├── 01. bronze_layer/
│   │   ├── NB_Bronze_Files_To_Delta.ipynb
│   │   ├── NB_Bronze_Shortcut.ipynb
│   │   ├── NB_load_web_logs.ipynb
│   │   └── PL_INGEST.json
│   │
│   ├── 02. silver_layer/
│   │   ├── Dataflow_crm_from_bronze_to_silver.pq
│   │   ├── NB_Silver_Analyze_Load_erp_tables.ipynb
│   │   ├── NB_Silver_Analyze_Load_sales_tables.ipynb
│   │   ├── NB_Silver_Clean_&_load_product_catalog.ipynb
│   │   └── Silver_Pipeline.json
│   │
│   └── 03. gold_layer/
│       ├── 01 Create Schemas.sql
│       ├── 02 Create Tables.sql
│       ├── 03 Add PK & FK constraints.sql
│       ├── 03.1 Verifica Primary Keys.sql
│       ├── 03.2 Verifica Foreign Keys.sql
│       ├── 04–14 Stored Procedures (.sql)
│       └── NB_Define_SQL_Gold_Datatype.ipynb
│
└── globalretail-source-data/
    ├── README.md
    ├── ecommerce/
    │   ├── .gitattributes
    │   └── web_logs.json
    ├── marketing/
    │   └── marketing_campaigns.csv
    └── product_catalog/
        └── product_catalog.json
```

# 🛒 GlobalRetail - Microsoft Fabric End-to-End Project

Welcome to the **GlobalRetail** project repository! This is an end-to-end implementation of an enterprise-grade retail data platform built natively on **Microsoft Fabric**. The project simulates a real-world retail ecosystem by ingesting data from three heterogeneous source systems, transforming it through a **Medallion Architecture** (Bronze, Silver, Gold), and exposing a business-ready dimensional model to Power BI via **Direct Lake**.

---

## 🧭 Navigation & Core Documentation

### 🏛️ Architecture & Guidelines


### 🔌 Data Sources
* [Azure Data Lake Storage Gen2 (ADLS2)](docs/Data%20Sources/ADLS2/ADLS2_source.md) — CRM & ERP landing zone, shortcut implementation, and file storage rules.
* [SQL Server (OLTP)](docs/Data%20Sources/SQL%20SERVER/SQL_SERVER_source.md) — Transactional database schema, setup scripts, constraints, and Data Gateway details.
* [GitHub Repository](docs/Data%20Sources/GITHUB/GITHUB_source.md) — Semi-structured datasets, HTTP integration patterns, and Git LFS handling.

---

## 🏗️ High-Level Architecture

The project architecture simulates a realistic enterprise environment by integrating three distinct source types:

```text
[ ADLS Gen2 Landing ] ──┐
[ Local SQL Server  ] ──┼──> [ Bronze Layer ] ──> [ Silver Layer ] ──> [ Gold Layer ] ──> [ Direct Lake Semantic Model ]
[ GitHub Repo (HTTP)] ──┘     (Raw Delta)        (Cleaned Delta)       (Star Schema DWH)             (Power BI)
```

### Source Systems Breakdown

| Source | Type | Hosted Data | Architectural Purpose |
| :--- | :--- | :--- | :--- |
| **[ADLS Gen2](docs/Data%20Sources/ADLS2/ADLS2_source.md)** | Batch CSV Exports | CRM (`customers`, `legacy_customers`) <br> ERP (`products`, `suppliers`, `inventory`) | Acts as the **Landing Zone**, decoupling analytics ingestion from source system schedules and preserving raw snapshots. |
| **[SQL Server](docs/Data%20Sources/SQL%20SERVER/SQL_SERVER_source.md)** | On-Premises OLTP Relational DB | `Orders`, `OrderDetails`, `OrderCampaign`, `Reviews` | Simulates the live operational database of an e-commerce platform using an On-Premises Data Gateway. |
| **[GitHub Repo](docs/Data%20Sources/GITHUB/GITHUB_source.md)** | HTTP Connector Files | `product_catalog.json`, `marketing_campaigns.csv`, `web_logs.json` | Simulates semi-structured data delivered via external REST APIs or third-party file distribution channels. |

---

## ⚙️ Microsoft Fabric Components Used

* **On-premises Data Gateway:** Bridges the local SQL Server OLTP database with cloud Fabric pipelines.
* **Lakehouses (`LH_Bronze`, `LH_Silver`):** Store raw landing files and cleaned Delta tables.
* **Data Warehouse (`WH_Retail`):** Hosts the Gold layer dimensional model across custom schemas (`_Shared_Dim`, `_Transactions`, `_Supply_Chain`, `_Marketing`).
* **Data Pipelines (`PL_INGEST`, `Silver_Pipeline`, `GOLD_Pipeline`):** Orchestrate dynamic metadata-driven ingestion and cross-layer data transformations.
* **PySpark Notebooks:** Process heavy workloads, flatten complex nested JSON fields, and execute data quality profiling.
* **Dataflow Gen2:** Performs low-code data transformations and cleaning for CRM datasets using Power Query.
* **Direct Lake Semantic Model (`SM_GlobalRetail`):** Delivers ultra-fast, zero-copy interactive Power BI reporting directly on top of the DWH storage.

---

## 🔄 Medallion Architecture Summary

### 1. [Bronze Layer](docs/Architecture/03.%20bronze_layer.md)
* **Objective:** Ingest raw source data as-is without modifying business content.
* **Key Patterns:** Metadata-driven ingestion controlled by `config_ingestion.csv`. Utilizes **OneLake Shortcuts** for zero-copy file access (`products.csv`) and dedicated Python notebooks for downloading large Git LFS files (`web_logs.json`). Sanitizes column names and adds ingestion timestamps before landing as Delta tables.

### 2. [Silver Layer](docs/Architecture/04.%20silver_layer.md)
* **Objective:** Clean, standardize, deduplicate, and flatten datasets.
* **Key Patterns:** Recursively cleans string spaces and empty strings to `NULL`. Expands nested JSON structures (e.g., product attributes and image arrays) into tabular format. Tracks run histories in a central audit table (`silver_audit_log`).

### 3. [Gold Layer](docs/Architecture/05.%20gold_layer.md)
* **Objective:** Serve a governed, high-performance star schema for reporting.
* **Key Patterns:** Notebook-assisted SQL data type profiling (`NB_Define_SQL_Gold_Datatype`). Enforces Primary Key and Foreign Key constraints across domain schemas. Dimension tables are reloaded via **Full Overwrite** (`TRUNCATE + INSERT`), while Fact tables use **Incremental Watermark Loading**.

---

## 🚀 Orchestration Pipeline (`ORCHESTRATION_PIPELINE`)

A single master pipeline handles the end-to-end execution of the platform in strict order:

1. **`PL_INGEST`**: Ingests raw files/tables into `LH_Bronze`.
2. **`Silver_Pipeline`**: Runs PySpark notebooks and Dataflow Gen2 jobs to populate `LH_Silver`.
3. **`GOLD_Pipeline`**: Executes T-SQL stored procedures in parallel phases (Dimensions first, then Facts) to update `WH_Retail`.
4. **Semantic Model Refresh**: Automatically updates `SM_GlobalRetail` for immediate Power BI reporting availability.

---

## 📁 Repository Structure

```text
Microsoft-Fabric-Project/
├── .gitattributes
├── LICENSE
├── README.md
├── docs/
│   ├── Architecture/
│   │   ├── 01. architecture_overview.md
│   │   ├── 02. naming_conventions.md
│   │   ├── 03. bronze_layer.md
│   │   ├── 04. silver_layer.md
│   │   ├── 05. gold_layer.md
│   │   └── 06. orchestration & lineage.md
│   ├── Data Sources/
│   │   ├── ADLS2/
│   │   │   ├── ADLS2_raw_data/
│   │   │   └── ADLS2_source.md
│   │   ├── GITHUB/
│   │   │   └── GITHUB_source.md
│   │   └── SQL SERVER/
│   │       ├── SQL_SERVER_raw_data/
│   │       ├── scripts/
│   │       └── SQL_SERVER_source.md
│   └── Images/
├── fabric_workspace/
│   ├── 01. bronze_layer/
│   ├── 02. silver_layer/
│   └── 03. gold_layer/
└── globalretail-source-data/
    ├── ecommerce/
    ├── marketing/
    └── product_catalog/
```

---
