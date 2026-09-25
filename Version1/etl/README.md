# Version 1 ETL

## What exists

Version 1 warehouse load is a T-SQL full load script:

`etl/04_etl_load.sql`

`audit.LoadHistory` on `EnterpriseData_DW` records a completed batch with:

- `SourceDatabase` = `AdventureWorks2022`
- `Notes` = `Full load from 04_etl_load.sql`

No SQL Server Agent jobs and no SSIS packages named for this project were found on the local instance.

There are no stored procedures on `EnterpriseData_DW` or `EnterpriseData_Staging`. Load logic lives in the script above.

## Warehouse load flow

`04_etl_load.sql` reads **AdventureWorks2022** (not `stg` tables) and populates `EnterpriseData_DW`:

1. `dw.DimDate` — calendar from 2010-01-01 through 2015-12-31 (`DateKey` = `yyyyMMdd`).
2. `dw.DimTerritory` — `Sales.SalesTerritory` plus `Person.CountryRegion`.
3. `dw.DimProduct` — `Production.Product` with subcategory and category names.
4. `dw.DimCustomer` — `Sales.Customer` with store or person name, email, and phone.
5. `dw.DimSalesPerson` — unknown member `(No Sales Person)` (`BusinessEntityID` NULL), then `Sales.SalesPerson`.
6. `dw.DimVendor` — `Purchasing.Vendor`.
7. `dw.DimLocation` — `Production.Location`.
8. `dw.FactSales` — sales order lines; cost and gross profit from `OrderQty * DimProduct.StandardCost`; unknown salesperson when `SalesPersonID` is null.
9. `dw.FactSalesQuota` — `Sales.SalesPersonQuotaHistory`, territory from the salesperson.
10. `dw.FactInventory` — `Production.ProductInventory` at a single snapshot date (`MAX(ModifiedDate)`); `DaysOfSupply` from average daily sales quantity; `StockStatus` from quantity vs reorder point and safety stock.
11. `dw.FactPurchase` — purchase order lines; `FulfillmentRatePct` = `ReceivedQty / OrderQty`.
12. Insert one `audit.LoadHistory` row.

## Staging

`EnterpriseData_Staging.stg` holds copies of eight AdventureWorks tables (Customer, Person, Product, ProductCategory, ProductSubcategory, SalesOrderDetail, SalesOrderHeader, SalesTerritory).

No staging load procedure, SSIS package, or SQL Agent job was found. Table definitions are in `sql/staging/`. Row counts on the inspected instance match the corresponding AdventureWorks source tables.

## Power BI / SSIS

This Version 1 repository does not include `.dtsx` packages.
