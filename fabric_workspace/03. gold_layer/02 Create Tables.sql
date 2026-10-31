
--============================
-- SCHEMA _Shared_Dim
--============================

-- dim_customers
DROP TABLE IF EXISTS [_Shared_Dim].[dim_customers];
GO
CREATE TABLE [_Shared_Dim].[dim_customers] (
    [CustomerID]        VARCHAR(10)     NOT NULL,   -- PK
    [FirstName]         VARCHAR(10)     NOT NULL,
    [LastName]          VARCHAR(10)     NOT NULL,
    [Gender]            VARCHAR(12)     NOT NULL,
    [DateOfBirth]       DATE            NOT NULL,
    [Email]             VARCHAR(48)     NOT NULL,
    [Phone]             VARCHAR(20)     NOT NULL,
    [Country]           VARCHAR(16)     NOT NULL,
    [City]              VARCHAR(10)     NOT NULL,
    [State]             VARCHAR(15)     NOT NULL,
    [PostalCode]        VARCHAR(10)     NOT NULL,
    [RegistrationDate]  DATE            NOT NULL,
    [CustomerSegment]   VARCHAR(16)     NOT NULL,
    [LoyaltyTier]       VARCHAR(10)     NOT NULL,
    [IsActive]          BIT             NOT NULL
);
GO
------------------------------------------------------------------------------------------------

-- dim_products
DROP TABLE IF EXISTS [_Shared_Dim].[dim_products];
GO
CREATE TABLE [_Shared_Dim].[dim_products] (
    [product_id]        VARCHAR(10)     NOT NULL,   -- PK
    [color]             VARCHAR(20)     NOT NULL,
    [warranty_months]   SMALLINT        NOT NULL,
    [weight_kg]         DECIMAL(8,3)    NOT NULL,
    [image_index]       INT             NOT NULL,
    [image_url]         VARCHAR(255)    NOT NULL,
    [SKU]               VARCHAR(30)     NOT NULL,
    [ProductName]       VARCHAR(150)    NOT NULL,
    [Category]          VARCHAR(50)     NOT NULL,
    [SubCategory]       VARCHAR(50)     NOT NULL,
    [Brand]             VARCHAR(50)     NOT NULL,
    [SupplierID]        VARCHAR(10)     NOT NULL,  -- FK dim_suppliers
    [UnitPrice]         DECIMAL(10,2)   NOT NULL,
    [Cost]              DECIMAL(10,2)   NOT NULL,
    [Status]            VARCHAR(20)     NOT NULL
);
GO
------------------------------------------------------------------------------------------------

-- dim_date
DROP TABLE IF EXISTS [_Shared_Dim].[dim_date];
GO

CREATE TABLE [_Shared_Dim].[dim_date] (
    [DateKey]           INT             NOT NULL,   -- PK format YYYYMMDD
    [FullDate]          DATE            NOT NULL,
    [Day]               SMALLINT        NOT NULL,
    [DayName]           VARCHAR(10)     NOT NULL,
    [DayOfWeek]         SMALLINT        NOT NULL,   
    [DayOfYear]         SMALLINT        NOT NULL,
    [Week]              SMALLINT        NOT NULL,
    [Month]             SMALLINT        NOT NULL,
    [MonthName]         VARCHAR(10)     NOT NULL,
    [Quarter]           SMALLINT        NOT NULL,
    [Year]              SMALLINT        NOT NULL,
    [IsWeekend]         BIT             NOT NULL,
    [IsLastDayOfMonth]  BIT             NOT NULL,
    [YearMonth]         INT             NOT NULL,   -- format YYYYMM
    [YearQuarter]       VARCHAR(7)      NOT NULL    -- format 'YYYY-Q1'
);
GO

--============================
-- SCHEMA _Transactions
--============================
-- fact_orders
DROP TABLE IF EXISTS [_Transactions].[fact_orders];
GO

CREATE TABLE [_Transactions].[fact_orders] (
    [OrderID]           VARCHAR(10)     NOT NULL,   -- PK
    [CustomerID]        VARCHAR(10)     NOT NULL,   -- FK dim_customers
    [OrderDate]         DATETIME2(6)    NOT NULL,
    [OrderStatus]       VARCHAR(12)     NOT NULL,
    [PaymentMethod]     VARCHAR(13)     NOT NULL,
    [ShippingMethod]    VARCHAR(14)     NOT NULL,
    [Currency]          VARCHAR(10)     NOT NULL,
    [OrderTotal]        DECIMAL(18,2)   NOT NULL,
    [DiscountAmount]    DECIMAL(18,2)   NOT NULL,
    [TaxAmount]         DECIMAL(18,2)   NOT NULL,
    [ShippingCost]      DECIMAL(18,2)   NOT NULL
);
GO


-- fact_orders_details 
DROP TABLE IF EXISTS [_Transactions].[fact_orders_details];
GO

CREATE TABLE [_Transactions].[fact_orders_details] (
    [OrderDetailID]     INT             NOT NULL,   -- PK
    [OrderID]           VARCHAR(10)     NOT NULL,   -- FK -> fact_orders
    [ProductID]         VARCHAR(10)     NOT NULL,   -- FK -> dim_products
    [Quantity]          INT             NOT NULL,
    [UnitPrice]         DECIMAL(12,2)   NOT NULL,
    [DiscountAmount]    DECIMAL(12,2)   NOT NULL
);
GO

--============================
-- SCHEMA _Supply_Chain
--============================
-- fact_inventory
DROP TABLE IF EXISTS [_Supply_Chain].[fact_inventory];
GO

CREATE TABLE [_Supply_Chain].[fact_inventory] (
    [WarehouseID]        VARCHAR(10)     NOT NULL,   -- PK composite (1/2)
    [WarehouseCity]      VARCHAR(13)     NOT NULL,
    [ProductID]          VARCHAR(10)     NOT NULL,   -- PK composite (2/2) + FK -> dim_products
    [StockQuantity]      INT             NOT NULL,
    [ReservedQuantity]   INT             NOT NULL,
    [AvailableQuantity]  INT             NOT NULL,
    [ReorderLevel]       INT             NOT NULL,
    [RestockQuantity]    INT             NOT NULL,
    [LastRestockDate]    DATE            NOT NULL,
    [InventoryStatus]    VARCHAR(10)     NOT NULL
);
GO


-- dim_suppliers
DROP TABLE IF EXISTS [_Supply_Chain].[dim_suppliers];
GO

CREATE TABLE [_Supply_Chain].[dim_suppliers] (
    [SupplierID]        VARCHAR(10)     NOT NULL,   -- PK
    [SupplierName]      VARCHAR(39)     NOT NULL,
    [Country]           VARCHAR(61)     NOT NULL,
    [Rating]            DECIMAL(5,4)    NOT NULL,
    [ContractType]      VARCHAR(10)     NOT NULL
);
GO


--============================
-- SCHEMA _Marketing
--============================
-- dim_campaign
DROP TABLE IF EXISTS [_Marketing].[dim_campaign];
GO

CREATE TABLE [_Marketing].[dim_campaign] (
    [CampaignID]        VARCHAR(10)     NOT NULL,   -- PK
    [CampaignName]      VARCHAR(20)     NOT NULL,
    [Channel]           VARCHAR(10)     NOT NULL,
    [Budget]            INT             NOT NULL
);
GO



-- fact_order_campaign
DROP TABLE IF EXISTS [_Marketing].[fact_order_campaign];
GO

CREATE TABLE [_Marketing].[fact_order_campaign] (
    [OrderID]            VARCHAR(10)     NOT NULL,   -- PK composite (1/2) + FK -> fact_orders
    [CampaignID]         VARCHAR(10)     NOT NULL,   -- PK composite (2/2) + FK -> dim_campaign
    [AttributionModel]   VARCHAR(13)     NOT NULL,
    [ConversionDays]     INT             NOT NULL,
    [CampaignChannel]    VARCHAR(10)     NOT NULL
);
GO


-- fact_web_logs

DROP TABLE IF EXISTS [_Marketing].[fact_web_logs];
GO

CREATE TABLE [_Marketing].[fact_web_logs] (
    [session_id]        VARCHAR(12)     NOT NULL,   -- PK 1/2
    [customer_id]        VARCHAR(10)     NOT NULL,   -- FK -> dim_customers
    [product_id]         VARCHAR(10)     NULL,      -- PK 2/2
    [browser]            VARCHAR(10)     NOT NULL,
    [country]            VARCHAR(16)     NOT NULL,
    [device]             VARCHAR(10)     NOT NULL,
    [duration]           INT             NOT NULL,   
    [event]              VARCHAR(13)     NOT NULL,
    [page]               VARCHAR(18)     NOT NULL,
    [timestamp]          DATETIME2(6)    NOT NULL    
);
GO


-- fact_reviews
DROP TABLE IF EXISTS [_Marketing].[fact_reviews];
GO

CREATE TABLE [_Marketing].[fact_reviews] (
    [ReviewID]           INT             NOT NULL,
    [CustomerID]         VARCHAR(10)     NOT NULL,
    [ProductID]          VARCHAR(10)     NOT NULL,
    [OrderID]            VARCHAR(10)     NULL,
    [Rating]             INT             NOT NULL,
    [ReviewTitle]        VARCHAR(50)     NULL,        -- wider to reduce lenght issues
    [ReviewText]         VARCHAR(200)   NULL,         
    [ReviewDate]         DATETIME2(6)    NOT NULL,
    [VerifiedPurchase]   BIT             NOT NULL,
    [HelpfulVotes]       INT             NOT NULL
);
GO








