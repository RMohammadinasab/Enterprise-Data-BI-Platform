USE EnterpriseData_Staging;
GO

CREATE TABLE stg.Customer (
    CustomerID      int                 IDENTITY(1,1) NOT NULL,
    PersonID        int                 NULL,
    StoreID         int                 NULL,
    TerritoryID     int                 NULL,
    AccountNumber   varchar(10)         NOT NULL,
    rowguid         uniqueidentifier    NOT NULL,
    ModifiedDate    datetime            NOT NULL,
    CONSTRAINT PK_stg_Customer PRIMARY KEY CLUSTERED (CustomerID)
);
GO
