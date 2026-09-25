USE master;
GO

IF DB_ID(N'EnterpriseData_DW') IS NULL
BEGIN
    CREATE DATABASE EnterpriseData_DW;
END
GO

USE EnterpriseData_DW;
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = N'dw')
    EXEC(N'CREATE SCHEMA dw');
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = N'semantic')
    EXEC(N'CREATE SCHEMA semantic');
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = N'audit')
    EXEC(N'CREATE SCHEMA audit');
GO
