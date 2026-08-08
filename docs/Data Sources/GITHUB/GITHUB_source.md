
# Data Source: GitHub Repository

## Overview

A GitHub repository is used to simulate data typically distributed via **file distribution services or external APIs**. Files are retrieved through Fabric's **HTTP connector**, which mimics how a pipeline would integrate with an external API endpoint in a real-world scenario.

This source hosts semi-structured and configuration-style datasets: a product catalog, marketing campaign data and web logs.

## Why GitHub as a Source?

This is not meant to represent "a code repository" in the traditional sense, it stands in for any external, file-based distribution channel. In a real enterprise environment, the same type of data could arrive from systems such as Shopify or JIRA.

In this project, the same pattern (small/medium structured or semi-structured files, retrieved via HTTP) is simulated using a public GitHub repository, with files fetched via `raw.githubusercontent.com` URLs rather than the standard `github.com` web UI URLs.

## Data Hosted

| Folder | File | Format | Description |
|---|---|---|---|
| `product_catalog/` | `product_catalog.json` | JSON | Product catalog data, small and infrequently updated, ideal to read directly via URL |
| `marketing/` | `marketing_campaigns.csv` | CSV | Marketing campaign master data |
| `ecommerce/` | `web_logs.json` | JSON | Web logs, large file, requires special handling (see below) |

All the data are stored here: [GlobalRetail Source Data](https://github.com/StefanoN98/Microsoft-Fabric-Project/tree/e485802398dbea7afc6a36d1cc4e9f462f698ae4/globalretail-source-data)

## Structure

```text
globalretail-source-data
│
├── ecommerce
│    └── web_logs.json
|
├──  marketing
│    └── marketing_campaigns.csv
|
└── product_catalog
      └── product_catalog.json
```
