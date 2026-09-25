USE EnterpriseData_DW;
GO

CREATE TABLE audit.LoadHistory (
    LoadHistoryId     bigint             IDENTITY(1,1) NOT NULL PRIMARY KEY,
    LoadBatchId       uniqueidentifier   NOT NULL,
    LoadStartedUtc    datetime2(3)       NOT NULL,
    LoadCompletedUtc  datetime2(3)       NOT NULL,
    SourceDatabase    sysname            NOT NULL,
    Notes             nvarchar(500)      NULL
);
GO
