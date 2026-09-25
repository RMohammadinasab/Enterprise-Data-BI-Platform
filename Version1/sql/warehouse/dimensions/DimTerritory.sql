USE EnterpriseData_DW;
GO

CREATE TABLE dw.DimTerritory (
    TerritoryKey        int             IDENTITY(1,1) NOT NULL PRIMARY KEY,
    TerritoryID         int             NOT NULL,
    TerritoryName       nvarchar(100)   NOT NULL,
    CountryRegionCode   nvarchar(10)    NOT NULL,
    CountryRegionName   nvarchar(100)   NULL,
    [Group]             nvarchar(100)   NULL,
    SalesYTD            money           NULL,
    SalesLastYear       money           NULL,
    CostYTD             money           NULL,
    CostLastYear        money           NULL
);
GO

CREATE UNIQUE INDEX UX_DimTerritory_TerritoryID ON dw.DimTerritory (TerritoryID);
GO
