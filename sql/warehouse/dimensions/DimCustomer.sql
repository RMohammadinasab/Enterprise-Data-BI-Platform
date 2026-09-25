USE EnterpriseData_DW;
GO

CREATE TABLE dw.DimCustomer (
    CustomerKey     int             IDENTITY(1,1) NOT NULL PRIMARY KEY,
    CustomerID      int             NOT NULL,
    CustomerType    nvarchar(20)    NOT NULL,
    CustomerName    nvarchar(200)   NOT NULL,
    PersonID        int             NULL,
    StoreID         int             NULL,
    TerritoryID     int             NULL,
    AccountNumber   nvarchar(30)    NULL,
    EmailAddress    nvarchar(100)   NULL,
    PhoneNumber     nvarchar(50)    NULL
);
GO

CREATE UNIQUE INDEX UX_DimCustomer_CustomerID ON dw.DimCustomer (CustomerID);
GO
