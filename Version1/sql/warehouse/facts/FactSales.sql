USE EnterpriseData_DW;
GO

CREATE TABLE dw.FactSales (
    FactSalesKey        bigint          IDENTITY(1,1) NOT NULL PRIMARY KEY,
    SalesOrderID        int             NOT NULL,
    SalesOrderDetailID  int             NOT NULL,
    OrderDateKey        int             NOT NULL,
    DueDateKey          int             NULL,
    ShipDateKey         int             NULL,
    ProductKey          int             NOT NULL,
    CustomerKey         int             NOT NULL,
    TerritoryKey        int             NOT NULL,
    SalesPersonKey      int             NOT NULL,
    OrderQty            smallint        NOT NULL,
    UnitPrice           money           NOT NULL,
    UnitPriceDiscount   money           NOT NULL,
    LineTotal           numeric(19,4)   NOT NULL,
    StandardCostTotal   money           NOT NULL,
    GrossProfit         money           NOT NULL,
    GrossMarginPct      decimal(9,4)    NOT NULL,
    OnlineOrderFlag     bit             NOT NULL,
    CONSTRAINT FK_FactSales_OrderDate FOREIGN KEY (OrderDateKey) REFERENCES dw.DimDate (DateKey),
    CONSTRAINT FK_FactSales_DueDate FOREIGN KEY (DueDateKey) REFERENCES dw.DimDate (DateKey),
    CONSTRAINT FK_FactSales_ShipDate FOREIGN KEY (ShipDateKey) REFERENCES dw.DimDate (DateKey),
    CONSTRAINT FK_FactSales_Product FOREIGN KEY (ProductKey) REFERENCES dw.DimProduct (ProductKey),
    CONSTRAINT FK_FactSales_Customer FOREIGN KEY (CustomerKey) REFERENCES dw.DimCustomer (CustomerKey),
    CONSTRAINT FK_FactSales_Territory FOREIGN KEY (TerritoryKey) REFERENCES dw.DimTerritory (TerritoryKey),
    CONSTRAINT FK_FactSales_SalesPerson FOREIGN KEY (SalesPersonKey) REFERENCES dw.DimSalesPerson (SalesPersonKey)
);
GO

CREATE UNIQUE INDEX UX_FactSales_Line ON dw.FactSales (SalesOrderID, SalesOrderDetailID);
CREATE INDEX IX_FactSales_OrderDateKey ON dw.FactSales (OrderDateKey);
CREATE INDEX IX_FactSales_ProductKey ON dw.FactSales (ProductKey);
CREATE INDEX IX_FactSales_CustomerKey ON dw.FactSales (CustomerKey);
CREATE INDEX IX_FactSales_TerritoryKey ON dw.FactSales (TerritoryKey);
GO
