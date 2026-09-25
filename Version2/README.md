# Version 2 — in progress

**Status: in progress.** This folder describes planned Version 2 work. It is not a completed implementation.

Version 2 builds on the Version 1 warehouse and semantic layer. It does **not** add new business questions. The six questions remain those defined in Version 1.

## Planned work

| Area | Plan | In this folder today |
|------|------|----------------------|
| Data collection | Collect / move operational data with **SQL Server Integration Services (SSIS)** | No `.dtsx` packages yet |
| Presentation | Show the Version 1 business questions as **Power BI dashboards** | No `.pbix` (or Power BI project) file yet |

Until those files exist, Version 1 remains the implemented source of truth for staging, the star schema, the T-SQL full load, and the six `semantic` views. See [`../Version1/README.md`](../Version1/README.md).

## Business questions (unchanged from Version 1)

These are the questions Version 2 dashboards are intended to present:

| # | Business question | Semantic view (Version 1) |
|---|-------------------|---------------------------|
| 1 | Which products are more profitable? | `semantic.vw_ProductProfitability` |
| 2 | Which regions are growing or declining in sales? | `semantic.vw_TerritorySalesTrend` |
| 3 | How do actual sales compare with targets? | `semantic.vw_SalesActualVsTarget` |
| 4 | Which customers show indicators of churn risk? | `semantic.vw_CustomerChurnRisk` |
| 5 | What is the current inventory status? | `semantic.vw_InventoryStatus` |
| 6 | Which products or customers have higher operational risk? | `semantic.vw_OperationalRisk` |

Source: [`../Version1/docs/business-requirements.md`](../Version1/docs/business-requirements.md).

## Folder structure (planned)

```text
Version2/
├── README.md          ← this file
├── ssis/              ← SSIS packages for data collection (not added yet)
└── powerbi/           ← Power BI dashboards for the six questions (not added yet)
```

## What is not claimed

- This version does **not** currently contain SSIS packages.
- This version does **not** currently contain a Power BI report.
- Version 2 does **not** introduce additional KPIs or business questions beyond Version 1.
