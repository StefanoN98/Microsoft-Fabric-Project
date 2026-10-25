# Microsoft-Fabric-Project

<img src="docs/Images/architecture/GlobalRetail_Architecture_Low_Level.drawio.svg"/>


The repository is organized into different sections to guide you through the solution, from the original data sources to the final analytical model.

## 🔌 Data Sources
Explore the different source systems, their ingestion methods, raw datasets and associated scripts used in the project.

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

---

## Repository Structure

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
