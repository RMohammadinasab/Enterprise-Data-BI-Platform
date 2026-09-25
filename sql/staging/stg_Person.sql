USE EnterpriseData_Staging;
GO

CREATE TABLE stg.Person (
    BusinessEntityID        int                 NOT NULL,
    PersonType              nchar(2)            NOT NULL,
    NameStyle               bit                 NOT NULL,
    Title                   nvarchar(16)        NULL,
    FirstName               nvarchar(100)       NOT NULL,
    MiddleName              nvarchar(100)       NULL,
    LastName                nvarchar(100)       NOT NULL,
    Suffix                  nvarchar(20)        NULL,
    EmailPromotion          int                 NOT NULL,
    AdditionalContactInfo   xml                 NULL,
    Demographics            xml                 NULL,
    rowguid                 uniqueidentifier    NOT NULL,
    ModifiedDate            datetime            NOT NULL,
    CONSTRAINT PK_stg_Person PRIMARY KEY CLUSTERED (BusinessEntityID)
);
GO
