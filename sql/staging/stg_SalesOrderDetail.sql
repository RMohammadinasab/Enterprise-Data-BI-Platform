USE EnterpriseData_Staging;
GO

CREATE TABLE stg.SalesOrderDetail (
    SalesOrderID            int                 NOT NULL,
    SalesOrderDetailID      int                 IDENTITY(1,1) NOT NULL,
    CarrierTrackingNumber   nvarchar(25)        NULL,
    OrderQty                smallint            NOT NULL,
    ProductID               int                 NOT NULL,
    SpecialOfferID          int                 NOT NULL,
    UnitPrice               money               NOT NULL,
    UnitPriceDiscount       money               NOT NULL,
    LineTotal               numeric(38,6)       NOT NULL,
    rowguid                 uniqueidentifier    NOT NULL,
    ModifiedDate            datetime            NOT NULL,
    CONSTRAINT PK_stg_SalesOrderDetail PRIMARY KEY CLUSTERED (SalesOrderID, SalesOrderDetailID)
);
GO
