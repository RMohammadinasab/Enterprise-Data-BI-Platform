USE EnterpriseData_DW;
GO

CREATE TABLE dw.DimProduct (
    ProductKey              int             IDENTITY(1,1) NOT NULL PRIMARY KEY,
    ProductID               int             NOT NULL,
    ProductName             nvarchar(100)   NOT NULL,
    ProductNumber           nvarchar(50)    NOT NULL,
    ProductLine             nchar(2)        NULL,
    ProductClass            nchar(2)        NULL,
    ProductStyle            nchar(2)        NULL,
    ProductSubcategoryID    int             NULL,
    ProductSubcategoryName  nvarchar(100)   NULL,
    ProductCategoryID       int             NULL,
    ProductCategoryName     nvarchar(100)   NULL,
    Color                   nvarchar(30)    NULL,
    Size                    nvarchar(10)    NULL,
    Weight                  decimal(8,2)    NULL,
    StandardCost            money           NOT NULL,
    ListPrice               money           NOT NULL,
    IsFinishedGood          bit             NOT NULL
);
GO

CREATE UNIQUE INDEX UX_DimProduct_ProductID ON dw.DimProduct (ProductID);
GO
