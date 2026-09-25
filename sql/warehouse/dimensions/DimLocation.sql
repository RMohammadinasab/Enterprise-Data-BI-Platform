USE EnterpriseData_DW;
GO

CREATE TABLE dw.DimLocation (
    LocationKey     int             IDENTITY(1,1) NOT NULL PRIMARY KEY,
    LocationID      smallint        NOT NULL,
    LocationName    nvarchar(100)   NOT NULL,
    CostRate        smallmoney      NOT NULL,
    Availability    decimal(8,2)    NOT NULL
);
GO

CREATE UNIQUE INDEX UX_DimLocation_LocationID ON dw.DimLocation (LocationID);
GO
