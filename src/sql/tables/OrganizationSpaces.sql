CREATE TABLE MonthlyOrganizationSpaceReporting(
    ReportingPeriodId int,
    ReportId int,
    Period varchar(25),
    ReportingPeriodStart date,
    ReportingPeriodEnd date,
    Accredited bit,
    ReportFundingSourceType int,
    OrganizationId int,
    OrganizationName varchar(100),
    Capacity int,
    TimeName varchar(10),
    AgeGroupName varchar(20),
    UtilizedSpaces int,
    UtilizedTitleISpaces int,
    UtilizedNonTitle1Spaces int,
    CDCRevenue decimal (18,2),
    CONSTRAINT MonthlyReport UNIQUE
    (ReportingPeriodId, OrganizationId, ReportFundingSourceType,
        TimeName, AgeGroupName)
);