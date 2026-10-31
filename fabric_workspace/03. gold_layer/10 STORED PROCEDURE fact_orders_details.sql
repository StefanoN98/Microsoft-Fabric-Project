CREATE OR ALTER PROCEDURE [_Transactions].[SP_load_fact_orders_details]
AS
BEGIN

    SET NOCOUNT ON;

    DECLARE @RowsInserted  INT;

    BEGIN TRY

        BEGIN TRANSACTION;

        -- Insert only rows where the combination between ordersID + ordersDetailID is not already present in Gold.
        -- No filter on the date: the comparison happens always on the entire source table        

        INSERT INTO _Transactions.fact_orders_details
        (
            OrderDetailID,
            OrderID,
            ProductID,
            Quantity,
            UnitPrice,
            DiscountAmount
        )
        SELECT
            s.OrderDetailID,
            s.OrderID,
            s.ProductID,
            s.Quantity,
            s.UnitPrice,
            s.DiscountAmount
        FROM LH_Silver.dbo.silver_order_details AS s
        WHERE NOT EXISTS (
            SELECT 1
            FROM _Transactions.fact_orders_details AS g
            WHERE g.OrderID = s.OrderID
              AND g.OrderDetailID = s.OrderDetailID
        );

        SET @RowsInserted = @@ROWCOUNT;

        COMMIT TRANSACTION;

        SELECT
            'SUCCESS' AS Status,
            @RowsInserted AS RowsLoaded;

    END TRY

    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SELECT
            'FAILED' AS Status,
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_MESSAGE() AS ErrorMessage;

    END CATCH

END;
GO

EXEC _Transactions.SP_load_fact_orders_details;
