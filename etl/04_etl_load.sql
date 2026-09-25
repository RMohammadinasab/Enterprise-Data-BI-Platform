USE EnterpriseData_DW;
GO

SET NOCOUNT ON;

DECLARE @MinDate date = '2010-01-01';
DECLARE @MaxDate date = '2015-12-31';

/* DimDate */
;WITH d AS (
    SELECT CAST(@MinDate AS date) AS FullDate
    UNION ALL
    SELECT DATEADD(day, 1, FullDate)
    FROM d
    WHERE FullDate < @MaxDate
)
INSERT INTO dw.DimDate (DateKey, FullDate, [Year], [Quarter], [Month], MonthName, [Day], DayOfWeek, DayName, IsWeekend, YearMonth, FiscalYear)
SELECT
    CONVERT(int, FORMAT(FullDate, 'yyyyMMdd')) AS DateKey,
    FullDate,
    YEAR(FullDate),
    DATEPART(quarter, FullDate),
    MONTH(FullDate),
    DATENAME(month, FullDate),
    DAY(FullDate),
    DATEPART(weekday, FullDate),
    DATENAME(weekday, FullDate),
    CASE WHEN DATEPART(weekday, FullDate) IN (1, 7) THEN 1 ELSE 0 END,
    FORMAT(FullDate, 'yyyy-MM'),
    CASE WHEN MONTH(FullDate) >= 7 THEN YEAR(FullDate) + 1 ELSE YEAR(FullDate) END
FROM d
OPTION (MAXRECURSION 32767);
GO

USE EnterpriseData_DW;
GO

INSERT INTO dw.DimTerritory (TerritoryID, TerritoryName, CountryRegionCode, CountryRegionName, [Group], SalesYTD, SalesLastYear, CostYTD, CostLastYear)
SELECT
    st.TerritoryID,
    st.Name,
    st.CountryRegionCode,
    cr.Name,
    st.[Group],
    st.SalesYTD,
    st.SalesLastYear,
    st.CostYTD,
    st.CostLastYear
FROM AdventureWorks2022.Sales.SalesTerritory st
LEFT JOIN AdventureWorks2022.Person.CountryRegion cr ON cr.CountryRegionCode = st.CountryRegionCode;
GO

INSERT INTO dw.DimProduct (
    ProductID, ProductName, ProductNumber, ProductLine, ProductClass, ProductStyle,
    ProductSubcategoryID, ProductSubcategoryName, ProductCategoryID, ProductCategoryName,
    Color, Size, Weight, StandardCost, ListPrice, IsFinishedGood
)
SELECT
    p.ProductID,
    p.Name,
    p.ProductNumber,
    p.ProductLine,
    p.Class,
    p.Style,
    psc.ProductSubcategoryID,
    psc.Name,
    pc.ProductCategoryID,
    pc.Name,
    p.Color,
    p.Size,
    p.Weight,
    p.StandardCost,
    p.ListPrice,
    p.FinishedGoodsFlag
FROM AdventureWorks2022.Production.Product p
LEFT JOIN AdventureWorks2022.Production.ProductSubcategory psc ON psc.ProductSubcategoryID = p.ProductSubcategoryID
LEFT JOIN AdventureWorks2022.Production.ProductCategory pc ON pc.ProductCategoryID = psc.ProductCategoryID;
GO

INSERT INTO dw.DimCustomer (CustomerID, CustomerType, CustomerName, PersonID, StoreID, TerritoryID, AccountNumber, EmailAddress, PhoneNumber)
SELECT
    c.CustomerID,
    CASE WHEN c.StoreID IS NOT NULL THEN N'Store' ELSE N'Individual' END,
    COALESCE(s.Name, CONCAT(per.FirstName, N' ', per.LastName)),
    c.PersonID,
    c.StoreID,
    c.TerritoryID,
    c.AccountNumber,
    ea.EmailAddress,
    pp.PhoneNumber
FROM AdventureWorks2022.Sales.Customer c
LEFT JOIN AdventureWorks2022.Sales.Store s ON s.BusinessEntityID = c.StoreID
LEFT JOIN AdventureWorks2022.Person.Person per ON per.BusinessEntityID = c.PersonID
OUTER APPLY (
    SELECT TOP (1) e.EmailAddress
    FROM AdventureWorks2022.Person.EmailAddress e
    WHERE e.BusinessEntityID = c.PersonID
    ORDER BY e.EmailAddressID
) ea
OUTER APPLY (
    SELECT TOP (1) pp.PhoneNumber
    FROM AdventureWorks2022.Person.PersonPhone pp
    WHERE pp.BusinessEntityID = c.PersonID
    ORDER BY pp.PhoneNumberTypeID
) pp;
GO

INSERT INTO dw.DimSalesPerson (BusinessEntityID, SalesPersonName, TerritoryID, SalesQuota, Bonus, CommissionPct)
VALUES (NULL, N'(No Sales Person)', NULL, NULL, NULL, NULL);
GO

INSERT INTO dw.DimSalesPerson (BusinessEntityID, SalesPersonName, TerritoryID, SalesQuota, Bonus, CommissionPct)
SELECT
    sp.BusinessEntityID,
    CONCAT(p.FirstName, N' ', p.LastName),
    sp.TerritoryID,
    sp.SalesQuota,
    sp.Bonus,
    sp.CommissionPct
FROM AdventureWorks2022.Sales.SalesPerson sp
JOIN AdventureWorks2022.Person.Person p ON p.BusinessEntityID = sp.BusinessEntityID;
GO

INSERT INTO dw.DimVendor (BusinessEntityID, AccountNumber, VendorName, CreditRating, PreferredVendorStatus, ActiveFlag)
SELECT
    v.BusinessEntityID,
    v.AccountNumber,
    v.Name,
    v.CreditRating,
    v.PreferredVendorStatus,
    v.ActiveFlag
FROM AdventureWorks2022.Purchasing.Vendor v;
GO

INSERT INTO dw.DimLocation (LocationID, LocationName, CostRate, Availability)
SELECT LocationID, Name, CostRate, Availability
FROM AdventureWorks2022.Production.Location;
GO

INSERT INTO dw.FactSales (
    SalesOrderID, SalesOrderDetailID, OrderDateKey, DueDateKey, ShipDateKey,
    ProductKey, CustomerKey, TerritoryKey, SalesPersonKey,
    OrderQty, UnitPrice, UnitPriceDiscount, LineTotal,
    StandardCostTotal, GrossProfit, GrossMarginPct, OnlineOrderFlag
)
SELECT
    sod.SalesOrderID,
    sod.SalesOrderDetailID,
    CONVERT(int, FORMAT(CAST(soh.OrderDate AS date), 'yyyyMMdd')),
    CONVERT(int, FORMAT(CAST(soh.DueDate AS date), 'yyyyMMdd')),
    CASE WHEN soh.ShipDate IS NULL THEN NULL ELSE CONVERT(int, FORMAT(CAST(soh.ShipDate AS date), 'yyyyMMdd')) END,
    dp.ProductKey,
    dc.CustomerKey,
    dt.TerritoryKey,
    COALESCE(dsp.SalesPersonKey, unk.SalesPersonKey),
    sod.OrderQty,
    sod.UnitPrice,
    sod.UnitPriceDiscount,
    sod.LineTotal,
    CAST(sod.OrderQty * dp.StandardCost AS money),
    CAST(sod.LineTotal - (sod.OrderQty * dp.StandardCost) AS money),
    CASE WHEN sod.LineTotal = 0 THEN 0 ELSE CAST((sod.LineTotal - (sod.OrderQty * dp.StandardCost)) / sod.LineTotal AS decimal(9,4)) END,
    soh.OnlineOrderFlag
FROM AdventureWorks2022.Sales.SalesOrderDetail sod
JOIN AdventureWorks2022.Sales.SalesOrderHeader soh ON soh.SalesOrderID = sod.SalesOrderID
JOIN dw.DimProduct dp ON dp.ProductID = sod.ProductID
JOIN dw.DimCustomer dc ON dc.CustomerID = soh.CustomerID
JOIN dw.DimTerritory dt ON dt.TerritoryID = soh.TerritoryID
LEFT JOIN dw.DimSalesPerson dsp ON dsp.BusinessEntityID = soh.SalesPersonID
CROSS JOIN (SELECT SalesPersonKey FROM dw.DimSalesPerson WHERE BusinessEntityID IS NULL) unk;
GO

INSERT INTO dw.FactSalesQuota (QuotaDateKey, SalesPersonKey, TerritoryKey, SalesQuotaAmount)
SELECT
    CONVERT(int, FORMAT(CAST(q.QuotaDate AS date), 'yyyyMMdd')),
    dsp.SalesPersonKey,
    dt.TerritoryKey,
    q.SalesQuota
FROM AdventureWorks2022.Sales.SalesPersonQuotaHistory q
JOIN dw.DimSalesPerson dsp ON dsp.BusinessEntityID = q.BusinessEntityID
JOIN AdventureWorks2022.Sales.SalesPerson sp ON sp.BusinessEntityID = q.BusinessEntityID
JOIN dw.DimTerritory dt ON dt.TerritoryID = sp.TerritoryID;
GO

DECLARE @SnapshotDate date = (
    SELECT CAST(MAX(ModifiedDate) AS date)
    FROM AdventureWorks2022.Production.ProductInventory
);

INSERT INTO dw.FactInventory (
    SnapshotDateKey, ProductKey, LocationKey, QuantityOnHand, InventoryValue,
    ReorderPoint, SafetyStockLevel, DaysOfSupply, StockStatus
)
SELECT
    CONVERT(int, FORMAT(@SnapshotDate, 'yyyyMMdd')),
    dp.ProductKey,
    dl.LocationKey,
    pi.Quantity,
    CAST(pi.Quantity * dp.StandardCost AS money),
    p.ReorderPoint,
    p.SafetyStockLevel,
    CASE
        WHEN sales.AvgDailyQty IS NULL OR sales.AvgDailyQty = 0 THEN NULL
        ELSE CAST(pi.Quantity / sales.AvgDailyQty AS decimal(12,2))
    END,
    CASE
        WHEN pi.Quantity = 0 THEN N'Out of Stock'
        WHEN pi.Quantity <= ISNULL(p.ReorderPoint, 0) THEN N'Below Reorder Point'
        WHEN pi.Quantity <= ISNULL(p.SafetyStockLevel, 0) THEN N'Below Safety Stock'
        ELSE N'Healthy'
    END
FROM AdventureWorks2022.Production.ProductInventory pi
JOIN dw.DimProduct dp ON dp.ProductID = pi.ProductID
JOIN dw.DimLocation dl ON dl.LocationID = pi.LocationID
JOIN AdventureWorks2022.Production.Product p ON p.ProductID = pi.ProductID
LEFT JOIN (
    SELECT
        fs.ProductKey,
        SUM(fs.OrderQty) / NULLIF(DATEDIFF(day, MIN(d.FullDate), MAX(d.FullDate)) + 1, 0) AS AvgDailyQty
    FROM dw.FactSales fs
    JOIN dw.DimDate d ON d.DateKey = fs.OrderDateKey
    GROUP BY fs.ProductKey
) sales ON sales.ProductKey = dp.ProductKey;
GO

INSERT INTO dw.FactPurchase (
    PurchaseOrderID, PurchaseOrderDetailID, OrderDateKey, ProductKey, VendorKey,
    OrderQty, ReceivedQty, RejectedQty, UnitPrice, LineTotal, FulfillmentRatePct
)
SELECT
    pod.PurchaseOrderID,
    pod.PurchaseOrderDetailID,
    CONVERT(int, FORMAT(CAST(poh.OrderDate AS date), 'yyyyMMdd')),
    dp.ProductKey,
    dv.VendorKey,
    pod.OrderQty,
    pod.ReceivedQty,
    pod.RejectedQty,
    pod.UnitPrice,
    pod.LineTotal,
    CASE WHEN pod.OrderQty = 0 THEN 0 ELSE CAST(pod.ReceivedQty / pod.OrderQty AS decimal(9,4)) END
FROM AdventureWorks2022.Purchasing.PurchaseOrderDetail pod
JOIN AdventureWorks2022.Purchasing.PurchaseOrderHeader poh ON poh.PurchaseOrderID = pod.PurchaseOrderID
JOIN dw.DimProduct dp ON dp.ProductID = pod.ProductID
JOIN dw.DimVendor dv ON dv.BusinessEntityID = poh.VendorID;
GO

INSERT INTO audit.LoadHistory (LoadBatchId, LoadStartedUtc, LoadCompletedUtc, SourceDatabase, Notes)
VALUES (NEWID(), SYSUTCDATETIME(), SYSUTCDATETIME(), N'AdventureWorks2022', N'Full load from 04_etl_load.sql');
GO
