CREATE OR ALTER PROCEDURE [_Supply_Chain].[SP_load_dim_suppliers]
AS
BEGIN

    SET NOCOUNT ON;

    DECLARE @RowsInserted INT;
    DECLARE @RowsSource INT;

    BEGIN TRY

        BEGIN TRANSACTION;

        -- Conta le righe disponibili in Silver, prima di toccare Gold
        SELECT @RowsSource = COUNT(*)
        FROM LH_Silver.dbo.silver_suppliers;

        TRUNCATE TABLE _Supply_Chain.dim_suppliers;

        INSERT INTO _Supply_Chain.dim_suppliers
        (
            SupplierID,
			SupplierName,
			Country,
			Rating,
			ContractType
        )
        SELECT
            SupplierID,
			SupplierName,
			Country,
			Rating,
			ContractType
        FROM LH_Silver.dbo.silver_suppliers;

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
EXEC _Supply_Chain.SP_load_dim_suppliers;