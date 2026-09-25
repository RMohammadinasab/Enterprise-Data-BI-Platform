USE EnterpriseData_DW;
GO

CREATE VIEW semantic.vw_CustomerChurnRisk
AS
WITH bounds AS (
    SELECT MAX(FullDate) AS MaxSalesDate FROM dw.DimDate d JOIN dw.FactSales fs ON fs.OrderDateKey = d.DateKey
),
customerActivity AS (
    SELECT
        c.CustomerKey,
        c.CustomerID,
        c.CustomerName,
        c.CustomerType,
        t.TerritoryName,
        COUNT(DISTINCT fs.SalesOrderID) AS OrderCount,
        SUM(fs.LineTotal) AS LifetimeRevenue,
        MAX(d.FullDate) AS LastOrderDate,
        SUM(CASE WHEN d.FullDate >= DATEADD(month, -12, b.MaxSalesDate) THEN fs.LineTotal ELSE 0 END) AS RevenueLast12M,
        SUM(CASE WHEN d.FullDate >= DATEADD(month, -24, b.MaxSalesDate)
                  AND d.FullDate < DATEADD(month, -12, b.MaxSalesDate) THEN fs.LineTotal ELSE 0 END) AS RevenuePrior12M
    FROM dw.FactSales fs
    JOIN dw.DimCustomer c ON c.CustomerKey = fs.CustomerKey
    LEFT JOIN dw.DimTerritory t ON t.TerritoryID = c.TerritoryID
    JOIN dw.DimDate d ON d.DateKey = fs.OrderDateKey
    CROSS JOIN bounds b
    GROUP BY c.CustomerKey, c.CustomerID, c.CustomerName, c.CustomerType, t.TerritoryName, b.MaxSalesDate
)
SELECT
    ca.*,
    DATEDIFF(day, ca.LastOrderDate, b.MaxSalesDate) AS DaysSinceLastOrder,
    CASE
        WHEN ca.RevenuePrior12M > 0
         AND ca.RevenueLast12M < ca.RevenuePrior12M * 0.70 THEN N'High'
        WHEN DATEDIFF(day, ca.LastOrderDate, b.MaxSalesDate) > 180
         AND ca.OrderCount >= 2 THEN N'High'
        WHEN ca.RevenuePrior12M > 0
         AND ca.RevenueLast12M < ca.RevenuePrior12M * 0.85 THEN N'Medium'
        WHEN DATEDIFF(day, ca.LastOrderDate, b.MaxSalesDate) > 120 THEN N'Medium'
        ELSE N'Low'
    END AS ChurnRiskLevel
FROM customerActivity ca
CROSS JOIN bounds b;
GO
