# Data Source: Azure Data Lake Storage Gen2

## Overview

Azure Data Lake Storage Gen2 (ADLS2) acts as the **Landing Zone** for all batch file exports coming from the CRM and ERP source systems. It sits between the source systems and Microsoft Fabric, decoupling ingestion from the applications that originally produce the data.

## Why ADLS Gen2 as a Landing Zone?

Using a Landing Zone is not a Fabric-specific requirement, but a deliberate architectural choice:

- **Decouples** source systems from the analytics platform
- **Preserves an original copy** of the raw data, independent of any transformation
- **Facilitates reuse** by other downstream systems, not just Fabric
- **Enables versioning and archiving** of historical exports
- **Makes ingestion independent** from source application availability/schedules

In short: ADLS Gen2 is not "just a folder", but the contractual boundary between source systems and the analytics platform.

## Data Hosted

| Domain | File | Description |
|---|---|---|
| CRM | `customers.csv` | Active customer master data |
| CRM | `legacy_customers.csv` | Legacy/historical customer records (intentionally "dirty" — see [Silver Layer](../silver_layer.md) for cleaning logic) |
| ERP | `products.csv` | Product master data |
| ERP | `suppliers.csv` | Supplier master data |
| ERP | `inventory.csv` | Warehouse inventory levels |

> These are exactly the type of datasets that are typically exported every night in real enterprise environments:
> - `CRM → CSV → Data Lake`
> - `ERP → CSV → Data Lake`

## Storage Structure
```text

stglobalretail
│
└── landing
    │
    ├── crm
    │   customers.csv
    │   legacy_customers.csv
    │
    ├── erp
    │   inventory.csv
    │   suppliers.csv
    │   │
    │   └── Shortcut
    │       products.csv
    │
    └── marketing
```

### Naming Convention

| Element | Value |
|---|---|
| Storage account | `stglobalretail` |
| Container | `landing` |
| Paths | `landing/crm/`, `landing/erp/`, `landing/marketing/` |

## Provisioning Notes

- **Hierarchical namespace** must be enabled at storage account creation time (this is what makes it "Gen2" and enables directory/ACL semantics, required for OneLake shortcuts and Fabric integration).
- **Access tier**: Hot (frequently accessed, everyday usage scenario).
- Data is uploaded manually for this project (via Azure Portal upload), simulating what would normally be an automated export job from CRM/ERP systems in a real environment.

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

