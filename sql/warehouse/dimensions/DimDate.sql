USE EnterpriseData_DW;
GO

CREATE TABLE dw.DimDate (
    DateKey             int             NOT NULL PRIMARY KEY,
    FullDate            date            NOT NULL,
    [Year]              smallint        NOT NULL,
    [Quarter]           tinyint         NOT NULL,
    [Month]             tinyint         NOT NULL,
    MonthName           nvarchar(20)    NOT NULL,
    [Day]               tinyint         NOT NULL,
    DayOfWeek           tinyint         NOT NULL,
    DayName             nvarchar(20)    NOT NULL,
    IsWeekend           bit             NOT NULL,
    YearMonth           char(7)         NOT NULL,
    FiscalYear          smallint        NOT NULL
);
GO
