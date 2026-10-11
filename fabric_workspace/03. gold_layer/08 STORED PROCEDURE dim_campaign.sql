CREATE OR ALTER PROCEDURE [_Marketing].[SP_load_dim_campaign]
AS
BEGIN

    SET NOCOUNT ON;

    DECLARE @RowsInserted INT;
    DECLARE @RowsSource INT;

    BEGIN TRY

        BEGIN TRANSACTION;

        -- Conta le righe disponibili in Silver, prima di toccare Gold
        SELECT @RowsSource = COUNT(*)
        FROM LH_Silver.dbo.silver_marketing_campaigns;

        TRUNCATE TABLE _Marketing.dim_campaign;

        INSERT INTO _Marketing.dim_campaign
        (
            CampaignID,
            CampaignName,
            Channel,
            Budget
        )
        SELECT
            CampaignID,
            CampaignName,
            Channel,
            Budget
        FROM LH_Silver.dbo.silver_marketing_campaigns;

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
EXEC _Marketing.SP_load_dim_campaign;