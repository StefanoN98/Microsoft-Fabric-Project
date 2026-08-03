# Data Source: SQL Server (OLTP)

## Overview

SQL Server hosts the **operational, transactional database** of the simulated e-commerce application. This source represents a live **OLTP system**, so the kind of database an application would read/write in real time.

> **Important distinction**: this is not a Data Warehouse. It is deliberately modeled as an OLTP system, with normalized tables, constraints, and indexes typical of a transactional database. Never call it "the Data Warehouse" during a review or interview, it plays a completely different role in the architecture.

## Data Hosted

All transactional/order-related data lives in this database, under a dedicated `sales` schema:

| Table | Description |
|---|---|
| `Orders` | Order header data (customer, date, status, payment, totals) |
| `OrderDetails` | Order line items (product, quantity, price, discount) |
| `OrderCampaign` | Attribution data linking orders to marketing campaigns |
| `Reviews` | Product reviews left by customers |

> Reviews are intentionally included here rather than treated as a separate system: many real-world e-commerce platforms store customer reviews directly in the application's operational database, not in a separate service.

## Database

- **Name**: `GlobalRetail_OLTP`
- **Schema**: `sales`

```text

GlobalRetail_OLTP
|
└── sales
    |
    ├── Orders
    ├── OrderDetails
    ├── Reviews
    ├── OrderCampaign
```


## Build Process

The database was built following a deliberate, ordered roadmap — schema and constraints are defined **before** any data is loaded:

```text

1. Database
2. Schema
3. Tables
4. Constraints
5. Indexes
6. Data loading
7. Database testing
8. Fabric connection
```

Why build constraints before loading data?
In a real environment, a database schema is defined before being populated. If a record violates a business rule, it must fail at load time, this is intentional, as it later allows demonstrating how the Fabric pipelines handle errors and "dirty" data during ingestion.


## Constraints & Business Rules
Referential integrity and business rules are enforced at the database level:

```sql
-- Foreign Keys
ALTER TABLE sales.OrderDetails
ADD CONSTRAINT FK_OrderDetails_Orders
FOREIGN KEY (OrderID)
REFERENCES sales.Orders(OrderID);

ALTER TABLE sales.OrderCampaign
ADD CONSTRAINT FK_OrderCampaign_Orders
FOREIGN KEY (OrderID)
REFERENCES sales.Orders(OrderID);

-- Business Rules
ALTER TABLE sales.Reviews
ADD CONSTRAINT CK_Reviews_Rating
CHECK (Rating BETWEEN 1 AND 5);

```

## Indexing Strategy
Non-clustered indexes are added on foreign keys and frequently filtered columns, based on expected query patterns (search by customer, by date, by status)

```sql

-- Search orders by customer
CREATE NONCLUSTERED INDEX IX_Orders_CustomerID
ON sales.Orders(CustomerID);

-- Search orders by date
CREATE NONCLUSTERED INDEX IX_Orders_OrderDate
ON sales.Orders(OrderDate);

-- Search orders by status
CREATE NONCLUSTERED INDEX IX_Orders_OrderStatus
ON sales.Orders(OrderStatus);

-- Join Order -> OrderDetails
CREATE NONCLUSTERED INDEX IX_OrderDetails_OrderID
ON sales.OrderDetails(OrderID);

```

## Data Loading
Data is loaded via BULK INSERT / OPENROWSET from local files, simulating an initial seed load of the OLTP system:

```sql

INSERT INTO sales.Reviews (ReviewID, CustomerID, ProductID, OrderID, Rating, ReviewText)
SELECT ReviewID, CustomerID, ProductID, OrderID, Rating, ReviewText
FROM OPENROWSET(BULK 'path/to/reviews.json', SINGLE_CLOB) AS j
CROSS APPLY OPENJSON(BulkColumn)
WITH (
    ReviewID    INT           '$.review_id',
    CustomerID  NVARCHAR(20)  '$.customer_id',
    ProductID   NVARCHAR(20)  '$.product_id',
    OrderID     NVARCHAR(100) '$.order_id',
    Rating      TINYINT       '$.rating'
);

```

See full scripts in infrastructure/sql_server/
- 01_script_create_tables_SSMS.sql
- 02_script_constraints_business_rules_tables.sql
- 03_set_index_tables.sql
- 04_script_insert_bulk.sql


 ## Connecting SQL Server to Fabric
 Since SQL Server runs on-premises (or in this project's case, on a local machine) and Fabric is cloud-based, an On-premises Data Gateway is required to bridge the two environments.

High-level steps:

1. Install the On-premises Data Gateway (Standard mode) on the machine hosting SQL Server
2. Register the gateway under the Fabric-linked account
3. Create a new connection in Fabric (Manage Connections and Gateways) of type SQL Server, using Basic Authentication and pointing to the gateway cluster
4. Reference this connection inside the ingestion pipeline's Copy Activity / Lookup Activity

See Gateway Setup (metti link) for the full walkthrough.
