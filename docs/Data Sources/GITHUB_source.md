
# Data Source: GitHub Repository

## Overview

A GitHub repository is used to simulate data typically distributed via **file distribution services or external APIs**. Files are retrieved through Fabric's **HTTP connector**, which mimics how a pipeline would integrate with an external API endpoint in a real-world scenario.

This source hosts semi-structured and configuration-style datasets: a product catalog, marketing campaign data and web logs.

## Why GitHub as a Source?

This is not meant to represent "a code repository" in the traditional sense, it stands in for any external, file-based distribution channel. In a real enterprise environment, the same type of data could arrive from systems such as:

- Shopify
- Magento
- Akeneo PIM
- SAP Product Catalog

In this project, the same pattern (small/medium structured or semi-structured files, retrieved via HTTP) is simulated using a public GitHub repository, with files fetched via `raw.githubusercontent.com` URLs rather than the standard `github.com` web UI URLs.

## Data Hosted

| Folder | File | Format | Description |
|---|---|---|---|
| `product_catalog/` | `product_catalog.json` | JSON | Product catalog data, small and infrequently updated, ideal to read directly via URL |
| `marketing/` | `marketing_campaigns.csv` | CSV | Marketing campaign master data |
| `ecommerce/` | `web_logs.json` | JSON | Web/clickstream logs, large file, requires special handling (see below) |


## Repository Structure

```text

globalretail-source-data
|
+-- ecommerce
|   web_logs.json
|
+-- marketing
|   marketing_campaigns.csv
|
+-- product_catalog
    product_catalog.json
```

## Fetching Files: `raw.githubusercontent.com`

Files are retrieved using the **raw content URL**, not the standard GitHub web interface URL:

Correct (raw content, usable by the HTTP connector):
https://raw.githubusercontent.com/<user>/<repo>/main/globalretail-source-data/


Incorrect (GitHub web UI, not a raw file endpoint):
https://github.com/<user>/<repo>/tree/main/globalretail-source-data


> The key difference: `raw.githubusercontent.com` replaces `github.com`, and the `tree` segment is removed from the path. Using the web UI URL inside a Copy Activity will fail, since it returns an HTML page rather than the raw file content.

### Required Header

To avoid GitHub blocking or throttling automated requests, a `User-Agent` header must be set on the HTTP connection:

User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64)


## Special Case: `web_logs.json` (Large File / Git LFS)

Unlike the other two files, `web_logs.json` is significantly large (~276 MB) and is tracked via **Git LFS** in the repository. This creates two implications:

1. **Copy Activity is not suitable**: a standard pipeline Copy Activity against the HTTP connector would time out or be highly inefficient for a file of this size.
2. **A dedicated notebook is used instead**: [`NB_load_web_logs`](../../fabric_workspace/bronze_layer/notebooks/NB_load_web_logs.py) downloads the file directly via Python (`urllib.request`) into the Bronze Lakehouse `Files` area, bypassing the pipeline's Copy Activity entirely.


```python

import urllib.request
import os

# Create target folder if it doesn't exist
os.makedirs("/lakehouse/default/Files/ecommerce", exist_ok=True)

# Direct GitHub LFS-resolved download URL
lfs_url = "https://raw.githubusercontent.com/<user>/<repo>/raw/main/globalretail-source-data/ecommerce/web_logs.json"
destination_path = "/lakehouse/default/Files/ecommerce/web_logs.json"

urllib.request.urlretrieve(lfs_url, destination_path)

Reminder: when a file is tracked with Git LFS, make sure the repository's .gitattributes correctly marks it, otherwise the raw URL may return the LFS pointer file instead of the actual binary content

```

## Ingestion Pattern in the Pipeline
Within **PL_INGEST**, GitHub-sourced files follow a dedicated branch:

- A Filter activity selects only rows from the configuration table where SourceType = GITHUB and excludes web_logs.json
- A ForEach loop iterates over the remaining files (product_catalog.json, marketing_campaigns.csv) and copies them via a standard Copy Activity, using Binary as the file format (since the folder contains both CSV and JSON files)
- web_logs.json is handled separately by NB_load_web_logs, triggered as its own pipeline branch

See Bronze Layer (metti link) for the full pipeline branching logic.


## Handling Nested JSON: product_catalog.json
product_catalog.json contains nested structures once loaded into Bronze:

- attributes: a struct field with sub-fields (color, warranty_months, weight_kg)
- images: an array of URL strings

These are not flattened at ingestion time — they remain as-is in Bronze (raw, unmodified) and are only flattened during Silver layer processing, via a dedicated recursive cleaning function. See Silver Layer for details.
