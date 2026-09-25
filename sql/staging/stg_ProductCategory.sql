USE EnterpriseData_Staging;
GO

CREATE TABLE stg.ProductCategory (
    ProductCategoryID   int                 IDENTITY(1,1) NOT NULL,
    Name                nvarchar(50)        NOT NULL,
    rowguid             uniqueidentifier    NOT NULL,
    ModifiedDate        datetime            NOT NULL,
    CONSTRAINT PK_stg_ProductCategory PRIMARY KEY CLUSTERED (ProductCategoryID)
);
GO
