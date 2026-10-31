CREATE OR ALTER PROCEDURE [_Shared_Dim].[SP_load_dim_date]
    @StartDate DATE = '2015-01-01',
    @EndDate   DATE = '2035-12-31'
AS
BEGIN

    SET NOCOUNT ON;

    DECLARE @RowsInserted INT;

    BEGIN TRY

        BEGIN TRANSACTION;

        DELETE FROM _Shared_Dim.dim_date;

        ;WITH
        E1(N)  AS (SELECT N FROM (VALUES(1),(1),(1),(1),(1),(1),(1),(1),(1),(1)) AS T(N)),
        E2(N)  AS (SELECT 1 FROM E1 a CROSS JOIN E1 b),
        E4(N)  AS (SELECT 1 FROM E2 a CROSS JOIN E2 b),
        E8(N)  AS (SELECT 1 FROM E4 a CROSS JOIN E4 b),
        Numbers AS (
            SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1 AS Number
            FROM E8
        ),
        NumbersFiltered AS (
            -- Filter before to calculate any dates
            -- keeping only necessary numbers to cover the requested interval
            SELECT Number
            FROM Numbers
            WHERE Number <= DATEDIFF(DAY, @StartDate, @EndDate)
        ),
        Dates AS (
            SELECT DATEADD(DAY, Number, @StartDate) AS FullDate
            FROM NumbersFiltered
        )

        INSERT INTO _Shared_Dim.dim_date
        (
            DateKey, FullDate, Day, DayName, DayOfWeek, DayOfYear,
            Week, Month, MonthName, Quarter, Year,
            IsWeekend, IsLastDayOfMonth, YearMonth, YearQuarter
        )
        SELECT
            CAST(FORMAT(FullDate, 'yyyyMMdd') AS INT),
            FullDate,
            DATEPART(DAY, FullDate),
            DATENAME(WEEKDAY, FullDate),
            DATEPART(WEEKDAY, FullDate),
            DATEPART(DAYOFYEAR, FullDate),
            DATEPART(WEEK, FullDate),
            DATEPART(MONTH, FullDate),
            DATENAME(MONTH, FullDate),
            DATEPART(QUARTER, FullDate),
            DATEPART(YEAR, FullDate),
            CASE WHEN DATEPART(WEEKDAY, FullDate) IN (1, 7) THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END,
            CASE WHEN FullDate = EOMONTH(FullDate) THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END,
            CAST(FORMAT(FullDate, 'yyyyMM') AS INT),
            FORMAT(FullDate, 'yyyy') + '-Q' + CAST(DATEPART(QUARTER, FullDate) AS VARCHAR(1))
        FROM Dates;

        SET @RowsInserted = @@ROWCOUNT;

        COMMIT TRANSACTION;

        SELECT
            'SUCCESS' AS Status,
            @RowsInserted AS RowsLoaded,
            @StartDate AS StartDate,
            @EndDate AS EndDate;

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

EXEC _Shared_Dim.SP_load_dim_date;
