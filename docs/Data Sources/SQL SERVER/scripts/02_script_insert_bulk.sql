
BULK INSERT sales.Orders
FROM 'C:\Users\Stefano\Desktop\FABRIC\My Project\Data\orders.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);


BULK INSERT sales.OrderDetails
FROM 'C:\Users\Stefano\Desktop\FABRIC\My Project\Data\order_details.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);


BULK INSERT sales.OrderCampaign
FROM 'C:\Users\Stefano\Desktop\FABRIC\My Project\Data\order_campaign.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);


INSERT INTO sales.Reviews (ReviewID, CustomerID, ProductID, OrderID, Rating, ReviewTitle, ReviewText, ReviewDate, VerifiedPurchase, HelpfulVotes)
SELECT ReviewID, CustomerID, ProductID, OrderID, Rating, ReviewTitle, ReviewText, ReviewDate, VerifiedPurchase, HelpfulVotes
FROM OPENROWSET(BULK 'C:\Users\Stefano\Desktop\FABRIC\My Project\Data\reviews.json', SINGLE_CLOB) AS j
CROSS APPLY OPENJSON(BulkColumn)
WITH (
    ReviewID            INT             '$.review_id',
    CustomerID          NVARCHAR(20)    '$.customer_id',
    ProductID           NVARCHAR(20)    '$.product_id',
    OrderID             NVARCHAR(100)   '$.order_id',
    Rating              TINYINT         '$.rating',
    ReviewTitle         NVARCHAR(250)   '$.review_title',
    ReviewText          NVARCHAR(MAX)   '$.review_text',
    ReviewDate          DATETIME2       '$.review_date',
    VerifiedPurchase    BIT             '$.verified_purchase',
    HelpfulVotes        INT             '$.helpful_votes'
);
