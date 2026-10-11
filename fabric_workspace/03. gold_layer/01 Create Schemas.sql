
-- Create schema for dimension tables shared between more departments
IF EXISTS (SELECT 1 FROM sys.schemas WHERE name = '_Shared_Dim')
    DROP SCHEMA _Shared_Dim;
GO
CREATE SCHEMA _Shared_Dim;
GO

-- Create schema for transaction orders
IF EXISTS (SELECT 1 FROM sys.schemas WHERE name = '_Transactions')
    DROP SCHEMA _Transactions;
GO
CREATE SCHEMA _Transactions;
GO

-- Create schema for supply chain tables
IF EXISTS (SELECT 1 FROM sys.schemas WHERE name = '_Supply_Chain')
    DROP SCHEMA _Supply_Chain;
GO
CREATE SCHEMA _Supply_Chain;
GO

-- Create schema for marketing information
IF EXISTS (SELECT 1 FROM sys.schemas WHERE name = '_Marketing')
    DROP SCHEMA _Marketing;
GO
CREATE SCHEMA _Marketing;
GO