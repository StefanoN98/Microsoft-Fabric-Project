CREATE OR ALTER PROCEDURE [_Shared_Dim].[SP_load_dim_products]
AS
BEGIN

    SET NOCOUNT ON;

    DECLARE @RowsInserted INT;
    DECLARE @RowsSource INT;

    BEGIN TRY

        BEGIN TRANSACTION;

        -- Conta le righe disponibili in Silver, prima di toccare Gold
        SELECT @RowsSource = COUNT(*)
        FROM LH_Silver.dbo.silver_products;

        TRUNCATE TABLE _Shared_Dim.dim_products;

        INSERT INTO _Shared_Dim.dim_products
        (
            product_id,
            color,
            warranty_months,
            weight_kg,
            image_index,
            image_url,
            SKU,
            ProductName,
            Category,
            SubCategory,
            Brand,
            SupplierID,
            UnitPrice,
            Cost,
            Status
        )
        SELECT
            spc.product_id,
            spc.color,
            spc.warranty_months,
            spc.weight_kg,
            spc.image_index,
            spc.image_url,
            sp.SKU,
            sp.ProductName,
            sp.Category,
            sp.SubCategory,
            sp.Brand,
            sp.SupplierID,
            sp.UnitPrice,
            sp.Cost,
            sp.Status
        FROM LH_Silver.dbo.silver_products AS sp
        INNER JOIN LH_Silver.dbo.silver_product_catalog AS spc
        ON sp.ProductID = spc.product_id;

        SET @RowsInserted = @@ROWCOUNT;

        COMMIT TRANSACTION;

        SELECT
            'SUCCESS' AS Status,
            @RowsSource AS RowsInSource,
            @RowsInserted AS RowsLoaded,
            @RowsSource - @RowsInserted AS RowsDifference;

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

-- Per eseguire la stored procedure
EXEC _Shared_Dim.SP_load_dim_products;