# Data Source: Azure Data Lake Storage Gen2

## Overview

Azure Data Lake Storage Gen2 (ADLS2) acts as the **Landing Zone** for all batch file exports coming from the CRM and ERP source systems. It sits between the source systems and Microsoft Fabric, decoupling ingestion from the applications that originally produce the data.

| Element | Value |
|---|---|
| Storage account | `stglobalretail` |
| Container | `landing` |
| Paths | `landing/crm/`, `landing/erp/`, `landing/marketing/` |

## Why ADLS Gen2 as a Landing Zone?

Using a Landing Zone is not a Fabric-specific requirement, but an architectural choice:

- **Decouples ingestion from source availability** isolates the analytics platform from source schedules, maintenance, and downtime.
- **Preserves an original copy** of the raw data, independent of any transformation
- **Facilitates reuse** by other downstream systems, not just Fabric

In short: ADLS Gen2 is not "just a folder", but the contractual boundary between source systems and the analytics platform.

## Data Hosted
 Data is uploaded manually for this project (via Azure Portal upload), simulating what would normally be an automated export job from CRM/ERP systems in a real environment.
| Domain | File | Description |
|---|---|---|
| CRM | `customers.csv` | Active customer master data |
| CRM | `legacy_customers.csv` | Legacy/historical customer records (intentionally "dirty" — see [Silver Layer](../silver_layer.md) for cleaning logic) |
| ERP | `products.csv` | Product master data |
| ERP | `suppliers.csv` | Supplier master data |
| ERP | `inventory.csv` | Warehouse inventory levels |

> These are exactly the type of datasets that are typically exported every night in real enterprise environments:

## Storage Structure
```text
stglobalretail
│
└── landing
    │
    ├── crm
    │   ├── customers.csv
    │   └── legacy_customers.csv
    │
    ├── erp
    │   ├── inventory.csv
    │   ├── suppliers.csv
    │   │
    │   └── Shortcut
    │       └── products.csv
    │
    └── marketing
```

## Ingestion Pattern in the Pipeline
Within **PL_INGEST**, ADLS2 files follow this branch:
- A Filter activity selects only rows from the configuration table where SourceType = ADLS
- A ForEach loop iterates through the filtered records, evaluating each item via an If Condition activity:
    - **Standard Copy:** If `CopyMode` is set to `COPY`, the pipeline executes a standard Copy Activity.
    - **Shortcut Creation:** Otherwise (`CopyMode` is set to `SHORTCUT`), the pipeline triggers a dedicated notebook to create a shortcut (see below).


## `products.csv` — OneLake Shortcut

Unlike the other ERP files (`suppliers.csv`, `inventory.csv`), `products.csv` is **not physically copied** into the Bronze Lakehouse. Instead, a **OneLake Shortcut** is created, pointing directly to its location in ADLS2 (`landing/erp/Shortcut/products.csv`).

This means:
- The file physically resides in ADLS2
- It is virtually exposed inside `LH_Bronze/Files/shortcut_adls/products.csv`, with no data duplication

The shortcut is created programmatically via a notebook calling the **Fabric REST API** (`/v1/workspaces/{workspaceId}/items/{lakehouseId}/shortcuts`), rather than through the Fabric UI, to demonstrate an automatable, repeatable provisioning pattern.

See [`NB_Bronze_Shortcut`](../../fabric_workspace/bronze_layer/notebooks/NB_Bronze_Shortcut.py) for implementation details.

---

## Related Documentation

- [Architecture Overview](../Architecture/architecture_overview.md)
- [Bronze Layer](../bronze_layer.md)
- [SQL Server Source](sql_server_source.md)
- [GitHub Source](github_source.md)

