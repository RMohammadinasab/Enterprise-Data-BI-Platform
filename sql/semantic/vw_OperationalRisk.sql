USE EnterpriseData_DW;
GO

CREATE VIEW semantic.vw_OperationalRisk
AS
WITH productRisk AS (
    SELECT
        N'Product' AS EntityType,
        CAST(p.ProductID AS nvarchar(50)) AS EntityID,
        p.ProductName AS EntityName,
        pr.GrossProfit,
        pr.Revenue,
        inv.WorstStockStatus,
        inv.MinDaysOfSupply,
        CAST(
            (CASE WHEN inv.WorstStockStatus = N'Out of Stock' THEN 40 ELSE 0 END)
          + (CASE WHEN inv.MinDaysOfSupply IS NOT NULL AND inv.MinDaysOfSupply < 14 THEN 30 ELSE 0 END)
          + (CASE WHEN pr.GrossMarginPct < 0.20 THEN 20 ELSE 0 END)
          + (CASE WHEN pr.Revenue >= 500000 THEN 10 ELSE 0 END)
        AS int) AS OperationalRiskScore
    FROM semantic.vw_ProductProfitability pr
    JOIN dw.DimProduct p ON p.ProductKey = pr.ProductKey
    LEFT JOIN (
        SELECT ProductKey,
               MIN(DaysOfSupply) AS MinDaysOfSupply,
               MAX(CASE StockStatus
                   WHEN N'Out of Stock' THEN 3
                   WHEN N'Below Reorder Point' THEN 2
                   WHEN N'Below Safety Stock' THEN 1
                   ELSE 0 END) AS StockRank,
               CASE MAX(CASE StockStatus WHEN N'Out of Stock' THEN 3 WHEN N'Below Reorder Point' THEN 2 WHEN N'Below Safety Stock' THEN 1 ELSE 0 END)
                   WHEN 3 THEN N'Out of Stock'
                   WHEN 2 THEN N'Below Reorder Point'
                   WHEN 1 THEN N'Below Safety Stock'
                   ELSE N'Healthy'
               END AS WorstStockStatus
        FROM dw.FactInventory
        GROUP BY ProductKey
    ) inv ON inv.ProductKey = pr.ProductKey
),
customerRisk AS (
    SELECT
        N'Customer' AS EntityType,
        CAST(c.CustomerID AS nvarchar(50)) AS EntityID,
        c.CustomerName AS EntityName,
        c.LifetimeRevenue AS GrossProfit,
        c.LifetimeRevenue AS Revenue,
        c.ChurnRiskLevel AS WorstStockStatus,
        CAST(c.DaysSinceLastOrder AS decimal(12,2)) AS MinDaysOfSupply,
        CAST(
            (CASE c.ChurnRiskLevel WHEN N'High' THEN 50 WHEN N'Medium' THEN 30 ELSE 10 END)
          + (CASE WHEN c.LifetimeRevenue >= 100000 THEN 30 ELSE 0 END)
          + (CASE WHEN c.RevenueLast12M < c.RevenuePrior12M THEN 20 ELSE 0 END)
        AS int) AS OperationalRiskScore
    FROM semantic.vw_CustomerChurnRisk c
)
SELECT * FROM productRisk
UNION ALL
SELECT * FROM customerRisk;
GO
