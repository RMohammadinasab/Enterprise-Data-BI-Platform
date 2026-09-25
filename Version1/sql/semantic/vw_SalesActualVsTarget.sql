USE EnterpriseData_DW;
GO

CREATE VIEW semantic.vw_SalesActualVsTarget
AS
WITH actual AS (
    SELECT
        d.YearMonth,
        d.[Year],
        d.[Month],
        t.TerritoryKey,
        t.TerritoryName,
        SUM(fs.LineTotal) AS ActualSales
    FROM dw.FactSales fs
    JOIN dw.DimDate d ON d.DateKey = fs.OrderDateKey
    JOIN dw.DimTerritory t ON t.TerritoryKey = fs.TerritoryKey
    GROUP BY d.YearMonth, d.[Year], d.[Month], t.TerritoryKey, t.TerritoryName
),
target AS (
    SELECT
        d.YearMonth,
        d.[Year],
        d.[Month],
        fq.TerritoryKey,
        SUM(fq.SalesQuotaAmount) AS TargetSales
    FROM dw.FactSalesQuota fq
    JOIN dw.DimDate d ON d.DateKey = fq.QuotaDateKey
    GROUP BY d.YearMonth, d.[Year], d.[Month], fq.TerritoryKey
)
SELECT
    a.YearMonth,
    a.[Year],
    a.[Month],
    a.TerritoryKey,
    a.TerritoryName,
    a.ActualSales,
    ISNULL(t.TargetSales, 0) AS TargetSales,
    a.ActualSales - ISNULL(t.TargetSales, 0) AS VarianceAmount,
    CASE
        WHEN ISNULL(t.TargetSales, 0) = 0 THEN NULL
        ELSE CAST(a.ActualSales / t.TargetSales AS decimal(9,4))
    END AS AttainmentPct
FROM actual a
LEFT JOIN target t
    ON t.TerritoryKey = a.TerritoryKey
   AND t.YearMonth = a.YearMonth;
GO
