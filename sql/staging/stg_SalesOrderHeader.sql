USE EnterpriseData_Staging;
GO

CREATE TABLE stg.SalesOrderHeader (
    SalesOrderID                int                 IDENTITY(1,1) NOT NULL,
    RevisionNumber              tinyint             NOT NULL,
    OrderDate                   datetime            NOT NULL,
    DueDate                     datetime            NOT NULL,
    ShipDate                    datetime            NULL,
    Status                      tinyint             NOT NULL,
    OnlineOrderFlag             bit                 NOT NULL,
    SalesOrderNumber            nvarchar(25)        NOT NULL,
    PurchaseOrderNumber         nvarchar(25)        NULL,
    AccountNumber               nvarchar(15)        NULL,
    CustomerID                  int                 NOT NULL,
    SalesPersonID               int                 NULL,
    TerritoryID                 int                 NULL,
    BillToAddressID             int                 NOT NULL,
    ShipToAddressID             int                 NOT NULL,
    ShipMethodID                int                 NOT NULL,
    CreditCardID                int                 NULL,
    CreditCardApprovalCode      varchar(15)         NULL,
    CurrencyRateID              int                 NULL,
    SubTotal                    money               NOT NULL,
    TaxAmt                      money               NOT NULL,
    Freight                     money               NOT NULL,
    TotalDue                    money               NOT NULL,
    Comment                     nvarchar(128)       NULL,
    rowguid                     uniqueidentifier    NOT NULL,
    ModifiedDate                datetime            NOT NULL,
    CONSTRAINT PK_stg_SalesOrderHeader PRIMARY KEY CLUSTERED (SalesOrderID)
);
GO
