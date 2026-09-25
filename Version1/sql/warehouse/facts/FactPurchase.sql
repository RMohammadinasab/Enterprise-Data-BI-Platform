USE EnterpriseData_DW;
GO

CREATE TABLE dw.FactPurchase (
    FactPurchaseKey         bigint          IDENTITY(1,1) NOT NULL PRIMARY KEY,
    PurchaseOrderID         int             NOT NULL,
    PurchaseOrderDetailID   int             NOT NULL,
    OrderDateKey            int             NOT NULL,
    ProductKey              int             NOT NULL,
    VendorKey               int             NOT NULL,
    OrderQty                smallint        NOT NULL,
    ReceivedQty             decimal(8,2)    NOT NULL,
    RejectedQty             decimal(8,2)    NOT NULL,
    UnitPrice               money           NOT NULL,
    LineTotal               money           NOT NULL,
    FulfillmentRatePct      decimal(9,4)    NOT NULL,
    CONSTRAINT FK_FactPurchase_OrderDate FOREIGN KEY (OrderDateKey) REFERENCES dw.DimDate (DateKey),
    CONSTRAINT FK_FactPurchase_Product FOREIGN KEY (ProductKey) REFERENCES dw.DimProduct (ProductKey),
    CONSTRAINT FK_FactPurchase_Vendor FOREIGN KEY (VendorKey) REFERENCES dw.DimVendor (VendorKey)
);
GO

CREATE UNIQUE INDEX UX_FactPurchase_Line ON dw.FactPurchase (PurchaseOrderID, PurchaseOrderDetailID);
GO
