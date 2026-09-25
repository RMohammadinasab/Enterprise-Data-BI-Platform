-- Rebuild EnterpriseData_DW from this repository.
-- Run from the Version1 folder:
--   sqlcmd -S .\SQL2022 -E -i sql\00_build_all.sql
-- AdventureWorks2022 must already exist on the instance.
-- Staging (EnterpriseData_Staging) is a separate database; see sql\staging.

:r sql\warehouse\00_create_database_and_schemas.sql
:r sql\warehouse\audit\LoadHistory.sql
:r sql\warehouse\dimensions\DimDate.sql
:r sql\warehouse\dimensions\DimTerritory.sql
:r sql\warehouse\dimensions\DimProduct.sql
:r sql\warehouse\dimensions\DimCustomer.sql
:r sql\warehouse\dimensions\DimSalesPerson.sql
:r sql\warehouse\dimensions\DimVendor.sql
:r sql\warehouse\dimensions\DimLocation.sql
:r sql\warehouse\facts\FactSales.sql
:r sql\warehouse\facts\FactSalesQuota.sql
:r sql\warehouse\facts\FactInventory.sql
:r sql\warehouse\facts\FactPurchase.sql
:r etl\04_etl_load.sql
:r sql\semantic\vw_ProductProfitability.sql
:r sql\semantic\vw_TerritorySalesTrend.sql
:r sql\semantic\vw_SalesActualVsTarget.sql
:r sql\semantic\vw_CustomerChurnRisk.sql
:r sql\semantic\vw_InventoryStatus.sql
:r sql\semantic\vw_OperationalRisk.sql

PRINT 'EnterpriseData_DW Version 1 build completed.';
