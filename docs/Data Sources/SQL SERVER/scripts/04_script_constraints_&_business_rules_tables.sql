USE GlobalRetail_OLTP;
GO

-- Foreign Keys
ALTER TABLE sales.OrderDetails
ADD CONSTRAINT FK_OrderDetails_Orders
FOREIGN KEY (OrderID) REFERENCES sales.Orders(OrderID);
GO

ALTER TABLE sales.OrderCampaign
ADD CONSTRAINT FK_OrderCampaign_Orders
FOREIGN KEY (OrderID) REFERENCES sales.Orders(OrderID);
GO

-- Regole business
ALTER TABLE sales.Reviews
ADD CONSTRAINT CK_Reviews_Rating
CHECK (Rating BETWEEN 1 AND 5);
GO

ALTER TABLE sales.OrderDetails
ADD CONSTRAINT CK_OrderDetails_Quantity
CHECK (Quantity > 0);
GO

ALTER TABLE sales.OrderDetails
ADD CONSTRAINT CK_OrderDetails_UnitPrice
CHECK (UnitPrice >= 0);
GO

ALTER TABLE sales.Orders
ADD CONSTRAINT CK_Orders_TotalAmount
CHECK (OrderTotal >= 0);
GO

ALTER TABLE sales.Orders
ADD CONSTRAINT CK_Orders_Currency
CHECK (Currency IN ('USD','EUR','GBP'));
GO