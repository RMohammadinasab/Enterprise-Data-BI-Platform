USE EnterpriseData_Staging;
GO

CREATE TABLE stg.ProductSubcategory (
    ProductSubcategoryID    int                 IDENTITY(1,1) NOT NULL,
    ProductCategoryID       int                 NOT NULL,
    Name                    nvarchar(50)        NOT NULL,
    rowguid                 uniqueidentifier    NOT NULL,
    ModifiedDate            datetime            NOT NULL,
    CONSTRAINT PK_stg_ProductSubcategory PRIMARY KEY CLUSTERED (ProductSubcategoryID)
);
GO
