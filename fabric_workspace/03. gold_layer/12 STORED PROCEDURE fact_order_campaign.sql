CREATE OR ALTER PROCEDURE [_Marketing].[SP_load_fact_order_campaign]
AS
BEGIN

    SET NOCOUNT ON;

    DECLARE @RowsInserted  INT;

    BEGIN TRY

        BEGIN TRANSACTION;

        INSERT INTO _Marketing.fact_order_campaign
        (
            OrderID,
            CampaignID,
            AttributionModel,
            ConversionDays,
            CampaignChannel
        )
        SELECT
            s.OrderID,
            s.CampaignID,
            s.AttributionModel,
            s.ConversionDays,
            s.CampaignChannel
        FROM LH_Silver.dbo.silver_order_campaign AS s
        WHERE NOT EXISTS (
            SELECT 1
            FROM _Marketing.fact_order_campaign AS g
            WHERE g.OrderID = s.OrderID
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

EXEC _Marketing.SP_load_fact_order_campaign;