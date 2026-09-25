# Enterprise Data & BI Platform — Version 1

SQL Server dimensional warehouse and semantic layer for a fictional multi-region manufacturer/distributor. **AdventureWorks2022** is the operational source dataset for this portfolio implementation.

This repository is Version 1 only: staging copies of selected source tables, a star-schema warehouse, six BI views, and the T-SQL full load that populated the warehouse.

## Business problem

Sales, purchasing, inventory, production, and customer data sit in different operational tables. Version 1 consolidates the measures needed for a unified management view of profitability, regional trend, quota attainment, customer recency/revenue risk, inventory status, and a combined operational-risk score.

## Business questions

1. Which products are more profitable?
2. Which regions are growing or declining in sales?
3. How do actual sales compare with targets?
4. Which customers are at risk of being lost?
5. What is the current inventory status?
6. Which products or customers have higher operational risk?

Each question is implemented as one view in schema `semantic` (see [docs/business-requirements.md](docs/business-requirements.md)).

## Architecture

```text
AdventureWorks2022
        ↓
Staging (EnterpriseData_Staging.stg)
        ↓
Enterprise Data Warehouse (EnterpriseData_DW.dw)
        ↓
Semantic / BI Layer (EnterpriseData_DW.semantic)
        ↓
Power BI (views as the contract; no .pbix in this repo)
```

Warehouse load in Version 1 reads **AdventureWorks2022** via `etl/04_etl_load.sql`. Staging holds the eight selected source tables but is not referenced by that load script. Details: [docs/architecture.md](docs/architecture.md).

## Source system

**AdventureWorks2022**

Selected tables copied into staging:

- Customer, Person, Product, ProductCategory, ProductSubcategory  
- SalesOrderDetail, SalesOrderHeader, SalesTerritory  

The warehouse also uses additional AdventureWorks tables required by the facts (for example `Sales.SalesPerson`, `Purchasing.Vendor` / purchase orders, `Production.Location` / `ProductInventory`, `Sales.SalesPersonQuotaHistory`). Those tables are not in `stg`.

## Staging layer

Database: `EnterpriseData_Staging`, schema `stg`.

Eight user tables, clustered primary keys, no foreign keys. Scripts: `sql/staging/`.

## Enterprise data warehouse

Database: `EnterpriseData_DW`

**Audit:** `audit.LoadHistory`

**Dimensions:** `DimDate`, `DimCustomer`, `DimProduct`, `DimLocation`, `DimSalesPerson`, `DimTerritory`, `DimVendor`

**Facts:** `FactSales` (order line), `FactSalesQuota`, `FactInventory` (product × location snapshot), `FactPurchase` (PO line)

Surrogate keys on dimensions except `DimDate` (`DateKey` = `yyyyMMdd`). Fact-to-dimension foreign keys are declared in SQL. Model notes: [docs/data-model.md](docs/data-model.md).

## Semantic layer

- `semantic.vw_ProductProfitability`
- `semantic.vw_TerritorySalesTrend`
- `semantic.vw_SalesActualVsTarget`
- `semantic.vw_CustomerChurnRisk`
- `semantic.vw_InventoryStatus`
- `semantic.vw_OperationalRisk`

## Technology stack

- Microsoft SQL Server (Version 1 built on a SQL Server 2022 instance)
- T-SQL (DDL, views, full-load INSERT)
- AdventureWorks2022 sample database
- Power BI as the intended reporting tool against `semantic` views

This Version 1 repository does not include cloud services, SSIS packages, or a Power BI report file.

## Repository structure

```text
Enterprise-Data-BI-Platform/
├── README.md
├── .gitignore
├── docs/
│   ├── architecture.md
│   ├── data-model.md
│   └── business-requirements.md
├── sql/
│   ├── 00_build_all.sql
│   ├── staging/
│   ├── warehouse/
│   │   ├── dimensions/
│   │   ├── facts/
│   │   └── audit/
│   ├── semantic/
│   └── validation/
├── etl/
│   ├── 04_etl_load.sql
│   └── README.md
└── powerbi/
    └── README.md
```

## Rebuild (warehouse)

Requires AdventureWorks2022 on the instance. From the repository root (adjust server name if needed):

```powershell
sqlcmd -S .\SQL2022 -E -i sql\00_build_all.sql
```

Staging DDL is separate: `sql/staging/00_create_staging_database.sql` then the `stg_*.sql` scripts.

Sample checks: `sql/validation/sample_kpi_queries.sql`.

## Version 1 scope

In scope: the objects and load documented above.

Out of scope: incremental load, SSIS, extra dimensions/facts/views, cloud, machine learning, and additional business questions.
