USE master;
GO

IF DB_ID(N'EnterpriseData_Staging') IS NULL
BEGIN
    CREATE DATABASE EnterpriseData_Staging;
END
GO

USE EnterpriseData_Staging;
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = N'stg')
    EXEC(N'CREATE SCHEMA stg');
GO
