USE GlobalRetail_OLTP;
GO

--------------------------------------------------
-- Orders
--------------------------------------------------
DROP TABLE IF EXISTS sales.Orders;
CREATE TABLE sales.Orders
(
    OrderID         NVARCHAR(100)   NOT NULL,
    CustomerID      NVARCHAR(100)   NOT NULL,
    OrderDate       DATETIME2       NOT NULL,
    OrderStatus     NVARCHAR(30)    NOT NULL,
    PaymentMethod   NVARCHAR(30)    NOT NULL,
    ShippingMethod  NVARCHAR(50)    NOT NULL,
    Currency        NVARCHAR(10)    NOT NULL,
    OrderTotal      DECIMAL(18,2)   NOT NULL,
    DiscountAmount  DECIMAL(18,2)   NOT NULL,
    TaxAmount       DECIMAL(18,2)   NOT NULL,
    ShippingCost    DECIMAL(18,2)   NOT NULL,
    PRIMARY KEY (OrderID)
);

GO

--------------------------------------------------
-- Order Details
--------------------------------------------------
DROP TABLE IF EXISTS sales.OrderDetails;
CREATE TABLE sales.OrderDetails
(
    OrderDetailID   INT             NOT NULL,
    OrderID         NVARCHAR(100)   NOT NULL,
    ProductID       NVARCHAR(20)    NOT NULL,
    Quantity        INT             NOT NULL,
    UnitPrice       DECIMAL(12,2)   NOT NULL,
    DiscountAmount  DECIMAL(12,2)   NOT NULL,
    PRIMARY KEY (OrderDetailID)
);
GO

--------------------------------------------------
-- Reviews
--------------------------------------------------

DROP TABLE IF EXISTS sales.Reviews;
CREATE TABLE sales.Reviews
(
    ReviewID            INT             NOT NULL,
    CustomerID          NVARCHAR(20)    NOT NULL,
    ProductID           NVARCHAR(20)    NOT NULL,
    OrderID             NVARCHAR(100)   NOT NULL,
    Rating              TINYINT         NOT NULL,
    ReviewTitle         NVARCHAR(250),
    ReviewText          NVARCHAR(MAX),
    ReviewDate          DATETIME2       NOT NULL,
    VerifiedPurchase    BIT             NOT NULL,
    HelpfulVotes        INT             NOT NULL,
    PRIMARY KEY (ReviewID)
);
GO

GO

--------------------------------------------------
-- Order Campaign
--------------------------------------------------
DROP TABLE IF EXISTS sales.OrderCampaign;
CREATE TABLE sales.OrderCampaign
(
    OrderID             NVARCHAR(100)   NOT NULL,
    CampaignID          NVARCHAR(20)    NOT NULL,
    AttributionModel    NVARCHAR(50)    NOT NULL,
    ConversionDays      INT             NOT NULL,
    CampaignChannel     NVARCHAR(50)    NOT NULL,
    PRIMARY KEY (OrderID, CampaignID)
);
GO

GO