USE EnterpriseData_DW;
GO

CREATE TABLE dw.FactInventory (
    FactInventoryKey    bigint          IDENTITY(1,1) NOT NULL PRIMARY KEY,
    SnapshotDateKey     int             NOT NULL,
    ProductKey          int             NOT NULL,
    LocationKey         int             NOT NULL,
    QuantityOnHand      smallint        NOT NULL,
    InventoryValue      money           NOT NULL,
    ReorderPoint        smallint        NULL,
    SafetyStockLevel    smallint        NULL,
    DaysOfSupply        decimal(12,2)   NULL,
    StockStatus         nvarchar(30)    NOT NULL,
    CONSTRAINT FK_FactInventory_Date FOREIGN KEY (SnapshotDateKey) REFERENCES dw.DimDate (DateKey),
    CONSTRAINT FK_FactInventory_Product FOREIGN KEY (ProductKey) REFERENCES dw.DimProduct (ProductKey),
    CONSTRAINT FK_FactInventory_Location FOREIGN KEY (LocationKey) REFERENCES dw.DimLocation (LocationKey)
);
GO

CREATE INDEX IX_FactInventory_ProductKey ON dw.FactInventory (ProductKey);
GO
