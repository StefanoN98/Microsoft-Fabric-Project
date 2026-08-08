USE GlobalRetail_OLTP;
GO

/*=============================================================
  Orders
=============================================================*/

-- Search orders by customer
CREATE NONCLUSTERED INDEX IX_Orders_CustomerID
ON sales.Orders(CustomerID);
GO

-- Search orders by date
CREATE NONCLUSTERED INDEX IX_Orders_OrderDate
ON sales.Orders(OrderDate);
GO

-- Search orders by status
CREATE NONCLUSTERED INDEX IX_Orders_OrderStatus
ON sales.Orders(OrderStatus);
GO


/*=============================================================
  OrderDetails
=============================================================*/

-- Join Order -> OrderDetails
CREATE NONCLUSTERED INDEX IX_OrderDetails_OrderID
ON sales.OrderDetails(OrderID);
GO

-- Product analysis
CREATE NONCLUSTERED INDEX IX_OrderDetails_ProductID
ON sales.OrderDetails(ProductID);
GO


/*=============================================================
  Reviews
=============================================================*/

-- Product reviews
CREATE NONCLUSTERED INDEX IX_Reviews_ProductID
ON sales.Reviews(ProductID);
GO

-- Customer reviews
CREATE NONCLUSTERED INDEX IX_Reviews_CustomerID
ON sales.Reviews(CustomerID);
GO

-- Reviews by date
CREATE NONCLUSTERED INDEX IX_Reviews_ReviewDate
ON sales.Reviews(ReviewDate);
GO


/*=============================================================
  OrderCampaign
=============================================================*/

-- Campaign analysis
CREATE NONCLUSTERED INDEX IX_OrderCampaign_CampaignID
ON sales.OrderCampaign(CampaignID);
GO