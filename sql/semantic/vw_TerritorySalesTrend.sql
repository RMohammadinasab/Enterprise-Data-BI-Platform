USE EnterpriseData_DW;
GO

CREATE VIEW semantic.vw_TerritorySalesTrend
AS
WITH monthly AS (
    SELECT
        t.TerritoryKey,
        t.TerritoryName,
        t.CountryRegionName,
        d.[Year],
        d.[Month],
        d.YearMonth,
        SUM(fs.LineTotal) AS Revenue
    FROM dw.FactSales fs
    JOIN dw.DimDate d ON d.DateKey = fs.OrderDateKey
    JOIN dw.DimTerritory t ON t.TerritoryKey = fs.TerritoryKey
    GROUP BY t.TerritoryKey, t.TerritoryName, t.CountryRegionName, d.[Year], d.[Month], d.YearMonth
),
yoy AS (
    SELECT
        cur.TerritoryKey,
        cur.TerritoryName,
        cur.CountryRegionName,
        cur.[Year],
        cur.[Month],
        cur.YearMonth,
        cur.Revenue AS CurrentYearRevenue,
        prev.Revenue AS PriorYearRevenue,
        cur.Revenue - ISNULL(prev.Revenue, 0) AS RevenueChange,
        CASE
            WHEN ISNULL(prev.Revenue, 0) = 0 THEN NULL
            ELSE CAST((cur.Revenue - prev.Revenue) / prev.Revenue AS decimal(9,4))
        END AS YoYGrowthPct
    FROM monthly cur
    LEFT JOIN monthly prev
        ON prev.TerritoryKey = cur.TerritoryKey
       AND prev.[Month] = cur.[Month]
       AND prev.[Year] = cur.[Year] - 1
)
SELECT
    *,
    CASE
        WHEN YoYGrowthPct IS NULL THEN N'New / No Prior Year'
        WHEN YoYGrowthPct >= 0.05 THEN N'Growing'
        WHEN YoYGrowthPct <= -0.05 THEN N'Declining'
        ELSE N'Stable'
    END AS TrendStatus
FROM yoy;
GO
