# Business requirements — Version 1

## Enterprise

The fictional organization operates across multiple sales regions, sells a diverse product set, serves store (organizational) and individual customers, and runs sales, purchasing, and inventory processes. Operational data lives in multiple subject areas of the source system (`AdventureWorks2022` in this portfolio).

## Problem

Management cannot get a single, consistent view of sales performance, product profitability, customer retention risk, inventory health, and purchasing fulfillment while those facts remain in separate operational tables.

## Questions and semantic views

Version 1 answers exactly these six questions. Mapping is from the view definitions on `EnterpriseData_DW`.

| # | Business question | Semantic view |
|---|-------------------|---------------|
| 1 | Which products are more profitable? | `semantic.vw_ProductProfitability` — revenue, COGS, gross profit, gross margin %, profit rank |
| 2 | Which regions are growing or declining in sales? | `semantic.vw_TerritorySalesTrend` — year-over-year revenue change and TrendStatus |
| 3 | How do actual sales compare with targets? | `semantic.vw_SalesActualVsTarget` — actual vs quota, variance, attainment % |
| 4 | Which customers show indicators of churn risk? | `semantic.vw_CustomerChurnRisk` — recency, 12-month revenue comparison, ChurnRiskLevel (rule-based; not a predictive model) |
| 5 | What is the current inventory status? | `semantic.vw_InventoryStatus` — on-hand qty, value, days of supply, stock status, stock risk score |
| 6 | Which products or customers have higher operational risk? | `semantic.vw_OperationalRisk` — scored product and customer rows |

Read-only sample queries for these views are in `sql/validation/sample_kpi_queries.sql`.

No additional KPIs, questions, or analytical models are in Version 1 beyond these views and the supporting star schema.
