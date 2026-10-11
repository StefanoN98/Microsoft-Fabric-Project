CREATE OR ALTER PROCEDURE [_Supply_Chain].[SP_load_fact_inventory]
AS
BEGIN

    SET NOCOUNT ON;

    DECLARE @RowsInserted  INT;

    BEGIN TRY

        BEGIN TRANSACTION;
        

        INSERT INTO _Supply_Chain.fact_inventory
        (
            WarehouseID,
            WarehouseCity,
            ProductID,
            StockQuantity,
            ReservedQuantity,
            AvailableQuantity,
            ReorderLevel,
            RestockQuantity,
            LastRestockDate,
            InventoryStatus
        )
        SELECT
            s.WarehouseID,
            s.WarehouseCity,
            ProductID,
            s.StockQuantity,
            s.ReservedQuantity,
            s.AvailableQuantity,
            s.ReorderLevel,
            s.RestockQuantity,
            s.LastRestockDate,
            s.InventoryStatus
        FROM LH_Silver.dbo.silver_inventory AS s
        WHERE NOT EXISTS (
            SELECT 1
            FROM _Supply_Chain.fact_inventory AS g
            WHERE g.WarehouseID = s.WarehouseID
              AND g.ProductID = s.ProductID
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

EXEC _Supply_Chain.SP_load_fact_inventory;