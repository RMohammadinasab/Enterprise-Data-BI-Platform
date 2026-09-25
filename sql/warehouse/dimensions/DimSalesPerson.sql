USE EnterpriseData_DW;
GO

CREATE TABLE dw.DimSalesPerson (
    SalesPersonKey      int             IDENTITY(1,1) NOT NULL PRIMARY KEY,
    BusinessEntityID    int             NULL,
    SalesPersonName     nvarchar(200)   NOT NULL,
    TerritoryID         int             NULL,
    SalesQuota          money           NULL,
    Bonus               money           NULL,
    CommissionPct       decimal(10,4)   NULL
);
GO

CREATE UNIQUE INDEX UX_DimSalesPerson_BusinessEntityID ON dw.DimSalesPerson (BusinessEntityID);
GO
