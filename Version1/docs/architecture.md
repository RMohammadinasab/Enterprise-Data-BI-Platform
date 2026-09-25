# Architecture — Version 1

## Conceptual flow

```text
Operational DB
        │
        ├── Sales
        ├── Purchasing
        ├── Inventory
        ├── Production
        └── Customers
        │
        ▼
Enterprise Data Platform
        │
        ▼
Staging Layer
        │
        ▼
Data Quality & Validation
        │
        ▼
Enterprise Data Warehouse
        │
        ▼
Semantic / BI Layer
        │
        ▼
Power BI Dashboards & KPIs
```

## Implemented flow (verified)

```text
AdventureWorks2022
        │
        ├──► EnterpriseData_Staging (stg.*)     ← eight selected source tables
        │
        └──► warehouse load reads the operational database
                    ↓
            EnterpriseData_DW (dw.* + audit.*)
                    ↓
            semantic.* views
                    ↓
            Power BI (consumer of semantic views; no report file in this repository)
```

Version 1 warehouse ETL (`etl/04_etl_load.sql`) loads dimensions and facts from **AdventureWorks2022**. It does not `SELECT` from `EnterpriseData_Staging`. Staging exists as a landing copy of the eight selected sales/product/customer tables.

No separate data-quality database objects (check constraints, DQ tables, or validation procedures) were found. `sql/validation/sample_kpi_queries.sql` is a read-only check against the semantic views.

## Layers

| Layer | Database / objects | Role in Version 1 |
|-------|--------------------|-------------------|
| Operational source | `AdventureWorks2022` | Operational source containing sales, purchasing, inventory, production, and customer-related data. |
| Staging | `EnterpriseData_Staging.stg` | Copies of Customer, Person, Product, ProductCategory, ProductSubcategory, SalesOrderDetail, SalesOrderHeader, SalesTerritory. No foreign keys. No load procedure found. |
| Warehouse | `EnterpriseData_DW.dw` | Star schema: seven dimensions, four facts. Surrogate keys on dimensions (except `DimDate`, which uses `yyyyMMdd`). |
| Audit | `EnterpriseData_DW.audit.LoadHistory` | One row per full load batch; Version 1 notes `Full load from 04_etl_load.sql`. |
| Semantic | `EnterpriseData_DW.semantic` | Six views that answer the six Version 1 business questions. |
| Presentation | Power BI | Intended consumer of `semantic` views. This repository has no `.pbix`. |

## Technology used in Version 1

- SQL Server (local instance used for this implementation: named instance `SQL2022`)
- T-SQL (`CREATE TABLE` / `CREATE VIEW` / full-load `INSERT`)
- AdventureWorks2022 as the source dataset

SSIS packages and SQL Agent jobs for this project were not found on the inspected instance.
