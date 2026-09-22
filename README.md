# Microsoft-Fabric-Project

The repository is organized into different sections to guide you through the solution, from the original data sources to the final analytical model.

## 📂 Data Sources

Explore the different source systems, their ingestion methods, and the raw data used in the project.

- **[ADLS Gen2](docs/Data%20Sources/ADLS2/ADLS2_source.md)**  
  Source overview and ingestion approach  
  → [Raw Data](docs/Data%20Sources/ADLS2/ADLS2_raw_data)

- **[GitHub](docs/Data%20Sources/GITHUB/GITHUB_source.md)**  
  Source overview and ingestion approach  
  → [Raw Data](globalretail-source-data)

- **[SQL Server](docs/Data%20Sources/SQL%20SERVER/SQL_SERVER_source.md)**  
  Source overview and ingestion approach  
  → [Raw Data](docs/Data%20Sources/SQL%20SERVER/SQL_SERVER_raw_data) · [SQL Scripts](docs/Data%20Sources/SQL%20SERVER/scripts)

---

## 🏗️ Architecture & Data Layers

Follow the data journey through the Fabric architecture, from raw ingestion to the final business-ready model.

1. **[Architecture Overview](docs/Architecture/01.%20architecture_overview.md)**  
   Overall architecture, data flow, Fabric components, and design principles.

2. **[Naming Conventions](docs/Architecture/02.%20naming_conventions.md)**  
   Naming standards adopted across the Fabric workspace.

3. **[Bronze Layer](docs/Architecture/03.%20bronze_layer.md)**  
   Raw data ingestion and metadata-driven ingestion process.

4. **[Silver Layer](docs/Architecture/04.%20silver_layer.md)**  
   Data cleansing, transformation, standardization, and quality checks.

5. **[Gold Layer](docs/Architecture/05.%20gold_layer.md)** 🚧 **Work in Progress**  
   Business-ready data model, star schema, and analytical layer.

