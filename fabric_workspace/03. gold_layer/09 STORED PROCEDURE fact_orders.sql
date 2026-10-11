CREATE OR ALTER PROCEDURE [_Transactions].[SP_load_fact_orders]
AS
BEGIN

    SET NOCOUNT ON;

    DECLARE @LastWatermark DATETIME2;
    DECLARE @RowsInserted  INT;

    BEGIN TRY

        BEGIN TRANSACTION;

        -- 1. Leggi la data più recente già presente in _Transactions
        SELECT @LastWatermark = MAX(OrderDate)
        FROM _Transactions.fact_orders;

        -- 2. Se la tabella è vuota (primo giro), forziamo una data sentinella molto vecchia
        IF @LastWatermark IS NULL
            SET @LastWatermark = '1900-01-01';

        -- 3. Inserisci gli ordini con data >= watermark (non > , per non perdere righe
        --    con la stessa data del giorno già processato), escludendo però quelli
        --    che sono già presenti in _Transactions, identificati tramite OrderID (chiave univoca)
        INSERT INTO _Transactions.fact_orders
        (
            OrderID,
            CustomerID,
            OrderDate,
            OrderStatus,
            PaymentMethod,
            ShippingMethod,
            Currency,
            OrderTotal,
            DiscountAmount,
            TaxAmount,
            ShippingCost
        )
        SELECT
            s.OrderID,
            s.CustomerID,
            s.OrderDate,
            s.OrderStatus,
            s.PaymentMethod,
            s.ShippingMethod,
            s.Currency,
            s.OrderTotal,
            s.DiscountAmount,
            s.TaxAmount,
            s.ShippingCost
        FROM LH_Silver.dbo.silver_orders AS s
        WHERE s.OrderDate >= @LastWatermark
          AND NOT EXISTS (
              SELECT 1
              FROM _Transactions.fact_orders AS g
              WHERE g.OrderID = s.OrderID
          );

        SET @RowsInserted = @@ROWCOUNT;

        COMMIT TRANSACTION;

        SELECT
            'SUCCESS' AS Status,
            @LastWatermark AS PreviousWatermark,
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

EXEC _Transactions.SP_load_fact_orders;