CREATE OR ALTER PROCEDURE [_Shared_Dim].[SP_load_dim_customers]
AS
BEGIN

    SET NOCOUNT ON;

    DECLARE @RowsInserted INT;
    DECLARE @RowsSource INT;

    BEGIN TRY

        BEGIN TRANSACTION;

        -- Count available rows in Silver before to modify Gold
        SELECT @RowsSource = COUNT(*)
        FROM LH_Silver.dbo.silver_customers;

        TRUNCATE TABLE _Shared_Dim.dim_customers;

        INSERT INTO _Shared_Dim.dim_customers
        (
            CustomerID,
            FirstName,
            LastName,
            Gender,
            DateOfBirth,
            Email,
            Phone,
            Country,
            City,
            State,
            PostalCode,
            RegistrationDate,
            CustomerSegment,
            LoyaltyTier,
            IsActive
        )
        SELECT
            CustomerID,
            FirstName,
            LastName,
            Gender,
            DateOfBirth,
            Email,
            Phone,
            Country,
            City,
            State,
            PostalCode,
            RegistrationDate,
            CustomerSegment,
            LoyaltyTier,
            IsActive
        FROM LH_Silver.dbo.silver_customers;

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
EXEC _Shared_Dim.SP_load_dim_customers;
