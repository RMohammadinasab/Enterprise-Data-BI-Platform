# Data model — Version 1

Definitions below match objects on `EnterpriseData_Staging` and `EnterpriseData_DW` as inspected on SQL Server. Column types match `INFORMATION_SCHEMA` / table scripts that correspond to those objects.

## Staging (`EnterpriseData_Staging`, schema `stg`)

Landing copies of eight AdventureWorks tables. No foreign keys. Primary keys:

| Table | Primary key |
|-------|-------------|
| `stg.Customer` | `CustomerID` (IDENTITY) |
| `stg.Person` | `BusinessEntityID` |
| `stg.Product` | `ProductID` (IDENTITY) |
| `stg.ProductCategory` | `ProductCategoryID` (IDENTITY) |
| `stg.ProductSubcategory` | `ProductSubcategoryID` (IDENTITY) |
| `stg.SalesOrderDetail` | `SalesOrderID`, `SalesOrderDetailID` (`SalesOrderDetailID` IDENTITY) |
| `stg.SalesOrderHeader` | `SalesOrderID` (IDENTITY) |
| `stg.SalesTerritory` | `TerritoryID` (IDENTITY) |

Row counts on the inspected instance:

| Table | Rows |
|-------|------|
| Customer | 19820 |
| Person | 19972 |
| Product | 504 |
| ProductCategory | 4 |
| ProductSubcategory | 37 |
| SalesOrderDetail | 121317 |
| SalesOrderHeader | 31465 |
| SalesTerritory | 10 |

## Audit (`EnterpriseData_DW.audit.LoadHistory`)

| Column | Type |
|--------|------|
| LoadHistoryId | bigint IDENTITY, PK |
| LoadBatchId | uniqueidentifier |
| LoadStartedUtc | datetime2(3) |
| LoadCompletedUtc | datetime2(3) |
| SourceDatabase | sysname |
| Notes | nvarchar(500) NULL |

Inspected content: one completed full load from `AdventureWorks2022`, notes `Full load from 04_etl_load.sql`.

## Dimensions (`EnterpriseData_DW.dw`)

Business keys have unique indexes (`UX_*`) except `DimDate`.

### `dw.DimDate`

- Grain: one calendar day.
- `DateKey` is the primary key (not IDENTITY), loaded as `yyyyMMdd`.
- Attributes: FullDate, Year, Quarter, Month, MonthName, Day, DayOfWeek, DayName, IsWeekend, YearMonth (`char(7)`), FiscalYear (July start: month >= 7 increments year).
- Inspected range: 2010-01-01 through 2015-12-31 (2191 rows).

### `dw.DimCustomer`

- Surrogate: `CustomerKey` IDENTITY.
- Business key: `CustomerID`.
- `CustomerType` is `Store` when source `StoreID` is not null, otherwise `Individual` (from load script).
- `CustomerName` is store name or person first + last name.
- Optional: PersonID, StoreID, TerritoryID, AccountNumber, EmailAddress, PhoneNumber.

### `dw.DimProduct`

- Surrogate: `ProductKey`. Business key: `ProductID`.
- Degenerate/denormalized: subcategory and category id + name, product line/class/style, cost and list price, `IsFinishedGood` from `FinishedGoodsFlag`.

### `dw.DimTerritory`

- Surrogate: `TerritoryKey`. Business key: `TerritoryID`.
- Includes country region code/name and source YTD / last-year sales and cost measures.

### `dw.DimSalesPerson`

- Surrogate: `SalesPersonKey`.
- Unique `BusinessEntityID` (NULL allowed for the unknown member).
- Load inserts `(No Sales Person)` with `BusinessEntityID` NULL before source salespeople.

### `dw.DimVendor`

- Surrogate: `VendorKey`. Business key: `BusinessEntityID`.
- CreditRating, PreferredVendorStatus, ActiveFlag.

### `dw.DimLocation`

- Surrogate: `LocationKey`. Business key: `LocationID`.
- CostRate, Availability.

Inspected row counts: DimCustomer 19820, DimDate 2191, DimLocation 14, DimProduct 504, DimSalesPerson 18, DimTerritory 10, DimVendor 104.

## Facts (`EnterpriseData_DW.dw`)

Foreign keys are enforced (see `sql/warehouse/facts`).

### `dw.FactSales`

- Grain: one sales order **line** (`SalesOrderID` + `SalesOrderDetailID`, unique index `UX_FactSales_Line`).
- Date roles: OrderDateKey (required), DueDateKey, ShipDateKey → `DimDate`.
- Dimensions: Product, Customer, Territory, SalesPerson.
- Degenerate: SalesOrderID, SalesOrderDetailID, OnlineOrderFlag.
- Measures: OrderQty, UnitPrice, UnitPriceDiscount, LineTotal, StandardCostTotal (`OrderQty * product StandardCost` at load), GrossProfit (`LineTotal - StandardCostTotal`), GrossMarginPct.
- Inspected rows: 121317 (same as `Sales.SalesOrderDetail` and `stg.SalesOrderDetail`).

### `dw.FactSalesQuota`

- Grain: one salesperson quota history row (no unique business-key index besides the surrogate PK).
- QuotaDateKey → DimDate; SalesPersonKey; TerritoryKey (territory of the salesperson at load).
- Measure: SalesQuotaAmount.
- Inspected rows: 139.

### `dw.FactInventory`

- Grain: product × location for a **single snapshot date** (snapshot = `MAX(ModifiedDate)` on `Production.ProductInventory` at load).
- Measures: QuantityOnHand, InventoryValue (`Quantity * StandardCost`), ReorderPoint, SafetyStockLevel, DaysOfSupply (quantity / average daily sales qty from FactSales; NULL if no sales rate).
- `StockStatus` at load: `Out of Stock` (qty = 0), `Below Reorder Point`, `Below Safety Stock`, else `Healthy`.
- Inspected rows: 1069.

### `dw.FactPurchase`

- Grain: one purchase order **line** (`PurchaseOrderID` + `PurchaseOrderDetailID`, unique index `UX_FactPurchase_Line`).
- OrderDateKey, ProductKey, VendorKey.
- Measures: OrderQty, ReceivedQty, RejectedQty, UnitPrice, LineTotal, FulfillmentRatePct (`ReceivedQty / OrderQty`).
- Inspected rows: 8845.

## Semantic views

View SQL is in `sql/semantic/` and matches `sys.sql_modules` on the inspected database.

| View | Grain / shape | Logic that can be read from the view |
|------|----------------|--------------------------------------|
| `vw_ProductProfitability` | One row per product | Sum of units, revenue, COGS, gross profit; margin; `RANK` by gross profit. |
| `vw_TerritorySalesTrend` | Territory × year-month | YoY same-month revenue; TrendStatus Growing (≥ +5%), Declining (≤ −5%), Stable, or New / No Prior Year. |
| `vw_SalesActualVsTarget` | Territory × year-month | Actual from FactSales; target from FactSalesQuota summed by territory-month; variance and attainment. |
| `vw_CustomerChurnRisk` | One row per customer | Recency vs max sales date; last-12 vs prior-12 revenue; ChurnRiskLevel High / Medium / Low (thresholds in the view; rule-based indicators, not a predictive model). |
| `vw_InventoryStatus` | One row per inventory fact | StockRiskScore 100 / 75 / 50 / 10 from StockStatus. |
| `vw_OperationalRisk` | Product rows UNION ALL customer rows | Product score from stock, days of supply, margin, revenue; customer score from churn level, lifetime revenue, YoY revenue direction. Shared column names on the union (`WorstStockStatus`, `MinDaysOfSupply`) are reused for customers (churn level and days since last order). |

## Relationship diagram (facts → dimensions)

```text
FactSales
  OrderDateKey / DueDateKey / ShipDateKey → DimDate
  ProductKey → DimProduct
  CustomerKey → DimCustomer
  TerritoryKey → DimTerritory
  SalesPersonKey → DimSalesPerson

FactSalesQuota
  QuotaDateKey → DimDate
  SalesPersonKey → DimSalesPerson
  TerritoryKey → DimTerritory

FactInventory
  SnapshotDateKey → DimDate
  ProductKey → DimProduct
  LocationKey → DimLocation

FactPurchase
  OrderDateKey → DimDate
  ProductKey → DimProduct
  VendorKey → DimVendor
```

`DimCustomer.TerritoryID` is a source business key, not an FK to `DimTerritory`. `vw_CustomerChurnRisk` joins territory on `t.TerritoryID = c.TerritoryID`.
