# Power BI (Version 1)

The BI contract for Version 1 is the `semantic` schema on `EnterpriseData_DW`.

| Semantic view | Business question |
|---------------|-------------------|
| `semantic.vw_ProductProfitability` | Which products are more profitable? |
| `semantic.vw_TerritorySalesTrend` | Which regions are growing or declining in sales? |
| `semantic.vw_SalesActualVsTarget` | How do actual sales compare with targets? |
| `semantic.vw_CustomerChurnRisk` | Which customers are at risk of being lost? |
| `semantic.vw_InventoryStatus` | What is the current inventory status? |
| `semantic.vw_OperationalRisk` | Which products or customers have higher operational risk? |

This repository does not contain a `.pbix` or Power BI project file.

Reports can be built in Power BI Desktop by importing or DirectQuerying those views. Connection details belong in the local Power BI environment and must not be committed if they include credentials.
