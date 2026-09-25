USE EnterpriseData_DW;
GO

PRINT '=== Top 10 products by gross profit ===';
SELECT TOP (10) ProductName, ProductCategoryName, Revenue, GrossProfit, GrossMarginPct, ProfitRank
FROM semantic.vw_ProductProfitability
ORDER BY GrossProfit DESC;

PRINT '=== Territory YoY trend (latest month in data) ===';
SELECT TOP (20) TerritoryName, CountryRegionName, YearMonth, CurrentYearRevenue, PriorYearRevenue, YoYGrowthPct, TrendStatus
FROM semantic.vw_TerritorySalesTrend
WHERE PriorYearRevenue IS NOT NULL
ORDER BY YearMonth DESC, YoYGrowthPct DESC;

PRINT '=== Actual vs target (territory, recent months) ===';
SELECT TOP (20) YearMonth, TerritoryName, ActualSales, TargetSales, VarianceAmount, AttainmentPct
FROM semantic.vw_SalesActualVsTarget
WHERE TargetSales > 0
ORDER BY YearMonth DESC, AttainmentPct ASC;

PRINT '=== Customers at high churn risk ===';
SELECT TOP (20) CustomerName, CustomerType, TerritoryName, LifetimeRevenue, DaysSinceLastOrder, RevenueLast12M, RevenuePrior12M, ChurnRiskLevel
FROM semantic.vw_CustomerChurnRisk
WHERE ChurnRiskLevel = N'High'
ORDER BY LifetimeRevenue DESC;

PRINT '=== Inventory exceptions ===';
SELECT StockStatus, COUNT(*) AS LocationProductCount, SUM(InventoryValue) AS InventoryValue
FROM semantic.vw_InventoryStatus
GROUP BY StockStatus
ORDER BY LocationProductCount DESC;

PRINT '=== Top operational risk ===';
SELECT TOP (20) EntityType, EntityName, OperationalRiskScore, WorstStockStatus, Revenue
FROM semantic.vw_OperationalRisk
ORDER BY OperationalRiskScore DESC, Revenue DESC;
GO
