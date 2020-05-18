CREATE TABLE MonthlyOrganizationRevenueReporting(
    ReportingPeriodId int,
    ReportId int,
    Period varchar(25),
    ReportingPeriodStart date,
    ReportingPeriodEnd date,
    Accredited bit,
    OrganizationId int,
    OrganizationName varchar(max),
    RetroactiveC4KRevenue bit,
    FamilyFeesRevenue decimal(18,2),
    C4KRevenue decimal(18,2),
    CDCRevenue decimal(18,2),
    TotalCapacity int,
    UtilizedSpaces int,
    CONSTRAINT MonthlyOrganizationRevenue UNIQUE
    (ReportingPeriodId, OrganizationId)
);