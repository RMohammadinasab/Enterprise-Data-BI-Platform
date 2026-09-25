USE EnterpriseData_DW;
GO

CREATE TABLE dw.FactSalesQuota (
    FactSalesQuotaKey   bigint      IDENTITY(1,1) NOT NULL PRIMARY KEY,
    QuotaDateKey        int         NOT NULL,
    SalesPersonKey      int         NOT NULL,
    TerritoryKey        int         NOT NULL,
    SalesQuotaAmount    money       NOT NULL,
    CONSTRAINT FK_FactSalesQuota_Date FOREIGN KEY (QuotaDateKey) REFERENCES dw.DimDate (DateKey),
    CONSTRAINT FK_FactSalesQuota_SalesPerson FOREIGN KEY (SalesPersonKey) REFERENCES dw.DimSalesPerson (SalesPersonKey),
    CONSTRAINT FK_FactSalesQuota_Territory FOREIGN KEY (TerritoryKey) REFERENCES dw.DimTerritory (TerritoryKey)
);
GO

CREATE INDEX IX_FactSalesQuota_QuotaDateKey ON dw.FactSalesQuota (QuotaDateKey);
GO
