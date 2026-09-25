USE EnterpriseData_DW;
GO

CREATE TABLE dw.DimVendor (
    VendorKey               int             IDENTITY(1,1) NOT NULL PRIMARY KEY,
    BusinessEntityID        int             NOT NULL,
    AccountNumber           nvarchar(30)    NOT NULL,
    VendorName              nvarchar(200)   NOT NULL,
    CreditRating            tinyint         NOT NULL,
    PreferredVendorStatus   bit             NOT NULL,
    ActiveFlag              bit             NOT NULL
);
GO

CREATE UNIQUE INDEX UX_DimVendor_BusinessEntityID ON dw.DimVendor (BusinessEntityID);
GO
