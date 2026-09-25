USE EnterpriseData_Staging;
GO

CREATE TABLE stg.SalesTerritory (
    TerritoryID         int                 IDENTITY(1,1) NOT NULL,
    Name                nvarchar(50)        NOT NULL,
    CountryRegionCode   nvarchar(3)         NOT NULL,
    [Group]             nvarchar(50)        NOT NULL,
    SalesYTD            money               NOT NULL,
    SalesLastYear       money               NOT NULL,
    CostYTD             money               NOT NULL,
    CostLastYear        money               NOT NULL,
    rowguid             uniqueidentifier    NOT NULL,
    ModifiedDate        datetime            NOT NULL,
    CONSTRAINT PK_stg_SalesTerritory PRIMARY KEY CLUSTERED (TerritoryID)
);
GO
