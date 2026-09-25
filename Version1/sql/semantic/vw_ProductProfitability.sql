USE EnterpriseData_DW;
GO

CREATE VIEW semantic.vw_ProductProfitability
AS
SELECT
    p.ProductKey,
    p.ProductID,
    p.ProductName,
    p.ProductCategoryName,
    p.ProductSubcategoryName,
    SUM(fs.OrderQty) AS UnitsSold,
    SUM(fs.LineTotal) AS Revenue,
    SUM(fs.StandardCostTotal) AS CostOfGoodsSold,
    SUM(fs.GrossProfit) AS GrossProfit,
    CASE WHEN SUM(fs.LineTotal) = 0 THEN 0
         ELSE CAST(SUM(fs.GrossProfit) / SUM(fs.LineTotal) AS decimal(9,4)) END AS GrossMarginPct,
    RANK() OVER (ORDER BY SUM(fs.GrossProfit) DESC) AS ProfitRank
FROM dw.FactSales fs
JOIN dw.DimProduct p ON p.ProductKey = fs.ProductKey
GROUP BY p.ProductKey, p.ProductID, p.ProductName, p.ProductCategoryName, p.ProductSubcategoryName;
GO
