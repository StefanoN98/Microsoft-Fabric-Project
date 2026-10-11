
-- =====================================================================================
-- FASE 1: DROP di TUTTE le Foreign Key (nessuna dipendenza da rispettare qui)
-- =====================================================================================

ALTER TABLE [_Shared_Dim].[dim_products] DROP CONSTRAINT IF EXISTS FK_dim_products_dim_suppliers;
GO
ALTER TABLE [_Transactions].[fact_orders] DROP CONSTRAINT IF EXISTS FK_fact_orders_dim_customers;
GO
ALTER TABLE [_Transactions].[fact_orders_details] DROP CONSTRAINT IF EXISTS FK_fact_orders_details_fact_orders;
GO
ALTER TABLE [_Transactions].[fact_orders_details] DROP CONSTRAINT IF EXISTS FK_fact_orders_details_dim_products;
GO
ALTER TABLE [_Supply_Chain].[fact_inventory] DROP CONSTRAINT IF EXISTS FK_fact_inventory_dim_products;
GO
ALTER TABLE [_Marketing].[fact_order_campaign] DROP CONSTRAINT IF EXISTS FK_fact_order_campaign_fact_orders;
GO
ALTER TABLE [_Marketing].[fact_order_campaign] DROP CONSTRAINT IF EXISTS FK_fact_order_campaign_dim_campaign;
GO
ALTER TABLE [_Marketing].[fact_web_logs] DROP CONSTRAINT IF EXISTS FK_fact_web_logs_dim_customers;
GO
ALTER TABLE [_Marketing].[fact_web_logs] DROP CONSTRAINT IF EXISTS FK_fact_web_logs_dim_products;
GO
ALTER TABLE [_Marketing].[fact_reviews] DROP CONSTRAINT IF EXISTS FK_fact_reviews_dim_customers;
GO
ALTER TABLE [_Marketing].[fact_reviews] DROP CONSTRAINT IF EXISTS FK_fact_reviews_dim_products;
GO
ALTER TABLE [_Marketing].[fact_reviews] DROP CONSTRAINT IF EXISTS FK_fact_reviews_fact_orders;
GO

-- =====================================================================================
-- FASE 2: DROP di TUTTE le Primary Key (ora nessuna FK le referenzia più)
-- =====================================================================================

ALTER TABLE [_Shared_Dim].[dim_customers] DROP CONSTRAINT IF EXISTS PK_dim_customers;
GO
ALTER TABLE [_Shared_Dim].[dim_products] DROP CONSTRAINT IF EXISTS PK_dim_products;
GO
ALTER TABLE [_Shared_Dim].[dim_date] DROP CONSTRAINT IF EXISTS PK_dim_date;
GO
ALTER TABLE [_Transactions].[fact_orders] DROP CONSTRAINT IF EXISTS PK_fact_orders;
GO
ALTER TABLE [_Transactions].[fact_orders_details] DROP CONSTRAINT IF EXISTS PK_fact_orders_details;
GO
ALTER TABLE [_Supply_Chain].[fact_inventory] DROP CONSTRAINT IF EXISTS PK_fact_inventory;
GO
ALTER TABLE [_Supply_Chain].[dim_suppliers] DROP CONSTRAINT IF EXISTS PK_dim_suppliers;
GO
ALTER TABLE [_Marketing].[dim_campaign] DROP CONSTRAINT IF EXISTS PK_dim_campaign;
GO
ALTER TABLE [_Marketing].[fact_order_campaign] DROP CONSTRAINT IF EXISTS PK_fact_order_campaign;
GO
ALTER TABLE [_Marketing].[fact_web_logs] DROP CONSTRAINT IF EXISTS PK_fact_web_logs;
GO
ALTER TABLE [_Marketing].[fact_reviews] DROP CONSTRAINT IF EXISTS PK_fact_reviews;
GO

-- =====================================================================================
-- FASE 3: CREATE di TUTTE le Primary Key (devono esistere prima delle FK)
-- =====================================================================================
-- PRIMARY KEY _Shared_Dim
ALTER TABLE [_Shared_Dim].[dim_customers]
ADD CONSTRAINT PK_dim_customers PRIMARY KEY NONCLUSTERED (CustomerID) NOT ENFORCED;
GO

ALTER TABLE [_Shared_Dim].[dim_products]
ADD CONSTRAINT PK_dim_products PRIMARY KEY NONCLUSTERED (product_id) NOT ENFORCED;
GO

ALTER TABLE [_Shared_Dim].[dim_date]
ADD CONSTRAINT PK_dim_date PRIMARY KEY NONCLUSTERED (DateKey) NOT ENFORCED;
GO
--------------------------------------------------------------------------------------------

-- PRIMARY KEY _Transactions
ALTER TABLE [_Transactions].[fact_orders]
ADD CONSTRAINT PK_fact_orders PRIMARY KEY NONCLUSTERED (OrderID) NOT ENFORCED;
GO

ALTER TABLE [_Transactions].[fact_orders_details]
ADD CONSTRAINT PK_fact_orders_details PRIMARY KEY NONCLUSTERED (OrderDetailID) NOT ENFORCED;
GO
--------------------------------------------------------------------------------------------

-- PRIMARY KEY _Supply_Chain
ALTER TABLE [_Supply_Chain].[fact_inventory]
ADD CONSTRAINT PK_fact_inventory PRIMARY KEY NONCLUSTERED (WarehouseID, ProductID) NOT ENFORCED;
GO

ALTER TABLE [_Supply_Chain].[dim_suppliers]
ADD CONSTRAINT PK_dim_suppliers PRIMARY KEY NONCLUSTERED (SupplierID) NOT ENFORCED;
GO
--------------------------------------------------------------------------------------------

-- PRIMARY KEY _Marketing
ALTER TABLE [_Marketing].[dim_campaign]
ADD CONSTRAINT PK_dim_campaign PRIMARY KEY NONCLUSTERED (CampaignID) NOT ENFORCED;
GO

ALTER TABLE [_Marketing].[fact_order_campaign]
ADD CONSTRAINT PK_fact_order_campaign PRIMARY KEY NONCLUSTERED (OrderID, CampaignID) NOT ENFORCED;
GO

ALTER TABLE [_Marketing].[fact_web_logs]
ADD CONSTRAINT PK_fact_web_logs PRIMARY KEY NONCLUSTERED (session_id) NOT ENFORCED;
GO

ALTER TABLE [_Marketing].[fact_reviews]
ADD CONSTRAINT PK_fact_reviews PRIMARY KEY NONCLUSTERED (ReviewID) NOT ENFORCED;
GO

-- =====================================================================================
-- FASE 4: CREATE di TUTTE le Foreign Key
-- ⚠ CORREZIONE CASE-SENSITIVE: product_id (minuscolo) invece di ProductID
-- =====================================================================================

ALTER TABLE [_Shared_Dim].[dim_products]
ADD CONSTRAINT FK_dim_products_dim_suppliers
FOREIGN KEY (SupplierID) REFERENCES [_Supply_Chain].[dim_suppliers] (SupplierID)
NOT ENFORCED;
GO

ALTER TABLE [_Transactions].[fact_orders]
ADD CONSTRAINT FK_fact_orders_dim_customers
FOREIGN KEY (CustomerID) REFERENCES [_Shared_Dim].[dim_customers] (CustomerID)
NOT ENFORCED;
GO

-- ⚠ Verifica prima che questa tabella esista con questo nome esatto (vedi query di verifica sopra)
ALTER TABLE [_Transactions].[fact_orders_details]
ADD CONSTRAINT FK_fact_orders_details_fact_orders
FOREIGN KEY (OrderID) REFERENCES [_Transactions].[fact_orders] (OrderID)
NOT ENFORCED;
GO

ALTER TABLE [_Transactions].[fact_orders_details]
ADD CONSTRAINT FK_fact_orders_details_dim_products
FOREIGN KEY (ProductID) REFERENCES [_Shared_Dim].[dim_products] (product_id)   -- CORRETTO: product_id minuscolo
NOT ENFORCED;
GO

ALTER TABLE [_Supply_Chain].[fact_inventory]
ADD CONSTRAINT FK_fact_inventory_dim_products
FOREIGN KEY (ProductID) REFERENCES [_Shared_Dim].[dim_products] (product_id)   -- CORRETTO
NOT ENFORCED;
GO

ALTER TABLE [_Marketing].[fact_order_campaign]
ADD CONSTRAINT FK_fact_order_campaign_fact_orders
FOREIGN KEY (OrderID) REFERENCES [_Transactions].[fact_orders] (OrderID)
NOT ENFORCED;
GO

ALTER TABLE [_Marketing].[fact_order_campaign]
ADD CONSTRAINT FK_fact_order_campaign_dim_campaign
FOREIGN KEY (CampaignID) REFERENCES [_Marketing].[dim_campaign] (CampaignID)
NOT ENFORCED;
GO

ALTER TABLE [_Marketing].[fact_web_logs]
ADD CONSTRAINT FK_fact_web_logs_dim_customers
FOREIGN KEY (customer_id) REFERENCES [_Shared_Dim].[dim_customers] (CustomerID)
NOT ENFORCED;
GO

ALTER TABLE [_Marketing].[fact_web_logs]
ADD CONSTRAINT FK_fact_web_logs_dim_products
FOREIGN KEY (product_id) REFERENCES [_Shared_Dim].[dim_products] (product_id)   -- CORRETTO
NOT ENFORCED;
GO

ALTER TABLE [_Marketing].[fact_reviews]
ADD CONSTRAINT FK_fact_reviews_dim_customers
FOREIGN KEY (CustomerID) REFERENCES [_Shared_Dim].[dim_customers] (CustomerID)
NOT ENFORCED;
GO

ALTER TABLE [_Marketing].[fact_reviews]
ADD CONSTRAINT FK_fact_reviews_dim_products
FOREIGN KEY (ProductID) REFERENCES [_Shared_Dim].[dim_products] (product_id)   -- CORRETTO
NOT ENFORCED;
GO

ALTER TABLE [_Marketing].[fact_reviews]
ADD CONSTRAINT FK_fact_reviews_fact_orders
FOREIGN KEY (OrderID) REFERENCES [_Transactions].[fact_orders] (OrderID)
NOT ENFORCED;
GO
