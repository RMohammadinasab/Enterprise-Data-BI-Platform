# Enterprise Data & BI Platform

SQL Server data warehouse and semantic BI layer for a fictional multi-region manufacturer/distributor. **AdventureWorks2022** is the operational source dataset for this portfolio implementation. The repository is organized by version folder: each version is self-contained so a reader can open one folder and see that version’s documentation, SQL objects, and load scripts.

---

## Table of Contents

- [Overview](#overview)
  - [What it does](#what-it-does)
  - [Problem it solves](#problem-it-solves)
  - [Business purpose](#business-purpose)
  - [Technical purpose](#technical-purpose)
- [Features](#features)
- [Versions](#versions)
- [Business questions](#business-questions)
- [Architecture](#architecture)
- [Database](#database)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Navigation](#navigation)
- [Security](#security)
- [Contributing](#contributing)
- [License](#license)

---

## Overview

### What it does

This project consolidates selected sales, purchasing, inventory, production, and customer data from **AdventureWorks2022** into a dimensional warehouse (`EnterpriseData_DW`) and six semantic views intended for management reporting in Power BI. Version 1 also maintains a staging database (`EnterpriseData_Staging`) as a landing copy of eight selected source tables.

### Problem it solves

Sales, purchasing, inventory, production, and customer facts sit in different operational tables. Management cannot get a single, consistent view of product profitability, regional sales trend, quota attainment, customer recency/revenue risk, inventory status, and a combined operational-risk score while those facts remain in the source system.

### Business purpose

Give a unified management view of the six Version 1 business questions (see [Business questions](#business-questions)), implemented as views in schema `semantic` on `EnterpriseData_DW`.

### Technical purpose

Provide a rebuildable T-SQL star schema (seven dimensions, four facts), an audit load table, a semantic layer, and a documented full-load script that reads **AdventureWorks2022**. The root of this repository is a **version index**; Version 1’s complete structure and documentation live under [`Version1/`](Version1/). Version 2 is **in progress** under [`Version2/`](Version2/) (SSIS data collection and Power BI dashboards for the same six questions).

---

## Features

Version 1 includes:

- Staging copies of eight selected AdventureWorks tables in `EnterpriseData_Staging.stg`
- Star-schema warehouse in `EnterpriseData_DW.dw` (seven dimensions, four facts)
- Audit table `audit.LoadHistory` recording the warehouse full-load batch
- Six semantic views in `EnterpriseData_DW.semantic`, one per business question
- T-SQL full load in [`Version1/etl/04_etl_load.sql`](Version1/etl/04_etl_load.sql) (reads **AdventureWorks2022**, not staging)
- Intended Power BI consumption of the semantic views (no report file in this repository)

---

## Versions

The repository is organized by version. **Each version folder is self-contained**: it holds its own documentation, SQL objects, and load scripts, so that version can be read and rebuilt on its own.

| Version | Status | Folder | Content |
|---------|--------|--------|---------|
| Version 1 | Complete (implemented) | [`Version1/`](Version1/) | Staging copies of eight selected source tables, a star-schema warehouse (7 dimensions, 4 facts), an audit load table, 6 semantic BI views, and the T-SQL full load that populated the warehouse. |
| Version 2 | **In progress** | [`Version2/`](Version2/) | Planned: data collection with **SSIS**, and **Power BI dashboards** for the same six Version 1 business questions. No SSIS packages or Power BI report files are in the repository yet. |

Open [`Version1/README.md`](Version1/README.md) for the implemented version. Open [`Version2/README.md`](Version2/README.md) for Version 2 scope and status.

---

## Business questions

Version 1 answers exactly these six questions. Each is implemented as one view in schema `semantic`. Source: [`Version1/docs/business-requirements.md`](Version1/docs/business-requirements.md).

| # | Business question | Semantic view |
|---|-------------------|---------------|
| 1 | Which products are more profitable? | `semantic.vw_ProductProfitability` |
| 2 | Which regions are growing or declining in sales? | `semantic.vw_TerritorySalesTrend` |
| 3 | How do actual sales compare with targets? | `semantic.vw_SalesActualVsTarget` |
| 4 | Which customers show indicators of churn risk? | `semantic.vw_CustomerChurnRisk` |
| 5 | What is the current inventory status? | `semantic.vw_InventoryStatus` |
| 6 | Which products or customers have higher operational risk? | `semantic.vw_OperationalRisk` |

---

## Architecture

Implemented flow (verified). Warehouse load reads **AdventureWorks2022**. Staging holds the eight selected source tables but is **not** referenced by the warehouse load script (`Version1/etl/04_etl_load.sql`).

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

The same diagram and framing appear in [`Version1/README.md`](Version1/README.md) and [`Version1/docs/architecture.md`](Version1/docs/architecture.md).

### Layer responsibilities

| Layer | Database / objects | Role |
|-------|--------------------|------|
| Operational source | `AdventureWorks2022` | Operational source containing sales, purchasing, inventory, production, and customer-related data. |
| Staging | `EnterpriseData_Staging.stg` | Landing copies of eight selected source tables. The warehouse load does not read this database. |
| Warehouse | `EnterpriseData_DW.dw` | Star schema: seven dimensions, four facts. |
| Audit | `EnterpriseData_DW.audit.LoadHistory` | One row per full-load batch. |
| Semantic | `EnterpriseData_DW.semantic` | Six views that answer the six Version 1 business questions. |
| Presentation | Power BI | Version 1: intended consumer of `semantic` views (no `.pbix` in Version 1). Version 2 (in progress): dashboards for the six Version 1 questions. |

---

## Database

| Database / schema | Role |
|-------------------|------|
| `AdventureWorks2022` | Operational source. Warehouse load reads this database. |
| `EnterpriseData_Staging.stg` | Staging copies of eight selected tables. |
| `EnterpriseData_DW.dw` | Dimensions and facts. |
| `EnterpriseData_DW.semantic` | Six BI views. |
| `EnterpriseData_DW.audit` | `LoadHistory`. |

**Staging tables:** `stg.Customer`, `stg.Person`, `stg.Product`, `stg.ProductCategory`, `stg.ProductSubcategory`, `stg.SalesOrderDetail`, `stg.SalesOrderHeader`, `stg.SalesTerritory`.

**Dimensions (`dw`):** `DimDate`, `DimCustomer`, `DimProduct`, `DimLocation`, `DimSalesPerson`, `DimTerritory`, `DimVendor`.

**Facts (`dw`):** `FactSales` (order line), `FactSalesQuota`, `FactInventory` (product × location snapshot), `FactPurchase` (PO line).

**Semantic views:** `vw_ProductProfitability`, `vw_TerritorySalesTrend`, `vw_SalesActualVsTarget`, `vw_CustomerChurnRisk`, `vw_InventoryStatus`, `vw_OperationalRisk`.

Grains, keys, and relationship notes: [`Version1/docs/data-model.md`](Version1/docs/data-model.md).

---

## Tech Stack

| Area | Technology |
|------|------------|
| Database engine | Microsoft SQL Server (built and verified on a SQL Server 2022 instance; named instance `SQL2022` in the rebuild command) |
| Implementation | T-SQL (DDL, views, full-load `INSERT`) |
| Source dataset | AdventureWorks2022 |
| Reporting | Power BI as the intended reporting tool against the `semantic` views (Version 2 dashboards: in progress) |
| Integration (Version 2, in progress) | SQL Server Integration Services (SSIS) for data collection |

**Not included today:** cloud services. Version 1 has no SSIS packages and no Power BI report file. Version 2 is in progress; those files have not been added yet.

---

## Project Structure

```text
Enterprise-Data-BI-Platform/
├── README.md              ← this file: project overview and version index
├── .gitignore
├── LICENSE
├── CONTRIBUTING.md
├── SECURITY.md
├── .github/
├── Version1/
│   ├── README.md          ← Version 1 overview (implemented)
│   ├── docs/              ← architecture, data model, business requirements
│   ├── sql/               ← staging, warehouse, semantic, validation
│   ├── etl/               ← full-load script and load documentation
│   └── powerbi/           ← semantic-layer / reporting notes
└── Version2/              ← in progress
    ├── README.md          ← Version 2 scope and status
    ├── ssis/              ← SSIS packages (not added yet)
    └── powerbi/           ← Power BI dashboards (not added yet)
```

---

## Getting Started

### Prerequisites

- A Microsoft SQL Server instance (Version 1 was built and verified on SQL Server 2022).
- **AdventureWorks2022** restored on that instance (required before the warehouse rebuild).
- `sqlcmd` available on the PATH (or run the equivalent from SQL Server Management Studio).

Adjust the instance name if it is not `.\SQL2022`. The documented command uses Windows authentication (`-E`).

### Rebuild (warehouse)

`Version1/sql/00_build_all.sql` uses `:r` include paths relative to the **`Version1`** folder (`sql\...` and `etl\04_etl_load.sql`). Run it from that working directory:

```powershell
cd Version1
sqlcmd -S .\SQL2022 -E -i sql\00_build_all.sql
```

That script creates `EnterpriseData_DW` (schemas `dw`, `semantic`, `audit`), warehouse tables, runs the full load from AdventureWorks2022, and creates the six semantic views. It does **not** build staging.

Staging is a separate database. From the same `Version1` folder: `sql/staging/00_create_staging_database.sql`, then the `stg_*.sql` scripts under `sql/staging/`.

Sample read-only checks against the semantic views: [`Version1/sql/validation/sample_kpi_queries.sql`](Version1/sql/validation/sample_kpi_queries.sql).

---

## Navigation

| To read about | Go to |
|---------------|-------|
| Version 1 overview | [`Version1/README.md`](Version1/README.md) |
| Business scenario and the questions the version answers | [`Version1/docs/business-requirements.md`](Version1/docs/business-requirements.md) |
| Layers and data flow | [`Version1/docs/architecture.md`](Version1/docs/architecture.md) |
| Tables, grains, keys, and view logic | [`Version1/docs/data-model.md`](Version1/docs/data-model.md) |
| Staging, warehouse, semantic, and validation SQL | [`Version1/sql/`](Version1/sql/) |
| Warehouse rebuild entry point | [`Version1/sql/00_build_all.sql`](Version1/sql/00_build_all.sql) |
| Load implementation | [`Version1/etl/`](Version1/etl/) |
| BI / reporting notes (Version 1) | [`Version1/powerbi/`](Version1/powerbi/) |
| Version 2 (in progress) | [`Version2/README.md`](Version2/README.md) |
| Version 2 SSIS (planned folder) | [`Version2/ssis/`](Version2/ssis/) |
| Version 2 Power BI (planned folder) | [`Version2/powerbi/`](Version2/powerbi/) |

---

## Security

See [`SECURITY.md`](SECURITY.md). Do not commit passwords, tokens, or credentialed connection strings. The rebuild command uses Windows authentication (`sqlcmd -S .\SQL2022 -E`).

---

## Contributing

See [`CONTRIBUTING.md`](CONTRIBUTING.md).

---

## License

This repository is licensed under the MIT License. See [`LICENSE`](LICENSE).
