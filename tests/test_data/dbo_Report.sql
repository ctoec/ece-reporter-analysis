create table Report
(
    Id                    int identity
        constraint PK_Report
            primary key,
    Type                  int not null,
    ReportingPeriodId     int not null,
    SubmittedAt           datetime2,
    OrganizationId        int,
    Accredited            bit,
    C4KRevenue            decimal(18, 2),
    RetroactiveC4KRevenue bit,
    FamilyFeesRevenue     decimal(18, 2),
    Comment               nvarchar(max)
)
go

create index IX_Report_OrganizationId
    on Report (OrganizationId)
go

create index IX_Report_ReportingPeriodId
    on Report (ReportingPeriodId)
go
SET IDENTITY_INSERT Report ON
INSERT INTO dbo.Report (Id, Type, ReportingPeriodId, SubmittedAt, OrganizationId, Accredited, C4KRevenue, RetroactiveC4KRevenue, FamilyFeesRevenue, Comment) VALUES (2290, 0, 10918, getdate(), 886, 1, 0.00, 0, null, null);
INSERT INTO dbo.Report (Id, Type, ReportingPeriodId, SubmittedAt, OrganizationId, Accredited, C4KRevenue, RetroactiveC4KRevenue, FamilyFeesRevenue, Comment) VALUES (2291, 0, 10919, getdate(), 886, 1, 0.00, 0, null, null);
INSERT INTO dbo.Report (Id, Type, ReportingPeriodId, SubmittedAt, OrganizationId, Accredited, C4KRevenue, RetroactiveC4KRevenue, FamilyFeesRevenue, Comment) VALUES (2292, 0, 10920, getdate(), 886, 1, 0.00, 0, null, null);
INSERT INTO dbo.Report (Id, Type, ReportingPeriodId, SubmittedAt, OrganizationId, Accredited, C4KRevenue, RetroactiveC4KRevenue, FamilyFeesRevenue, Comment) VALUES (2293, 0, 10921, null, 886, 1, 0.00, 0, null, null);
INSERT INTO dbo.Report (Id, Type, ReportingPeriodId, SubmittedAt, OrganizationId, Accredited, C4KRevenue, RetroactiveC4KRevenue, FamilyFeesRevenue, Comment) VALUES (2294, 0, 10950, null, 886, 1, 0.00, 0, null, null);
INSERT INTO dbo.Report (Id, Type, ReportingPeriodId, SubmittedAt, OrganizationId, Accredited, C4KRevenue, RetroactiveC4KRevenue, FamilyFeesRevenue, Comment) VALUES (2295, 0, 10950, null, 887, 0, 0.00, 0, null, null);