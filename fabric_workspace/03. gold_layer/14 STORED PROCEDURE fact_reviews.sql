CREATE OR ALTER PROCEDURE [_Marketing].[SP_load_fact_reviews]
AS
BEGIN

    SET NOCOUNT ON;

    DECLARE @RowsInserted  INT;

    BEGIN TRY

        BEGIN TRANSACTION;
        

        INSERT INTO _Marketing.fact_reviews
        (
            ReviewID,
            CustomerID,
            ProductID,
            OrderID,
            Rating,
            ReviewTitle,
            ReviewText,
            ReviewDate,
            VerifiedPurchase,
            HelpfulVotes

    )
        SELECT
            s.ReviewID,
            s.CustomerID,
            s.ProductID,
            s.OrderID,
            s.Rating,
            s.ReviewTitle,
            s.ReviewText,
            s.ReviewDate,
            s.VerifiedPurchase,
            s.HelpfulVotes
        FROM LH_Silver.dbo.silver_reviews AS s
        WHERE NOT EXISTS (
            SELECT 1
            FROM _Marketing.fact_reviews AS g
            WHERE g.ReviewID = s.ReviewID
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

EXEC _Marketing.SP_load_fact_reviews;