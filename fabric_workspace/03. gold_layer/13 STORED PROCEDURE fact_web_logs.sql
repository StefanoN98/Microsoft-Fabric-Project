CREATE OR ALTER PROCEDURE [_Marketing].[SP_load_fact_web_logs]
AS
BEGIN

    SET NOCOUNT ON;

    DECLARE @RowsInserted  INT;

    BEGIN TRY

        BEGIN TRANSACTION;
        

        INSERT INTO _Marketing.fact_web_logs
        (
            session_id,
            customer_id,
            product_id,        
            browser,
            country,
            device,
            duration,
            event,          
            page,
            timestamp
    )
        SELECT
            s.session_id,
            s.customer_id,
            s.product_id,        
            s.browser,
            s.country,
            s.device,
            s.duration,
            s.event,          
            s.page,
            s.timestamp
        FROM LH_Silver.dbo.silver_web_logs AS s
        WHERE NOT EXISTS (
            SELECT 1
            FROM _Marketing.fact_web_logs AS g
            WHERE g.session_id = s.session_id
              AND g.product_id = s.product_id
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

EXEC _Marketing.SP_load_fact_web_logs;