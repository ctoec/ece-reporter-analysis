-- Add CSVs from data folder with Accredited and TitleI as bits
ALTER TABLE Rates ADD RegionId int, AgeGroupID int, TimeID int;
UPDATE Rates
SET Rates.AgeGroupID =
        CASE AgeGroup
            WHEN 'Infant/Toddler' THEN 0
            WHEN 'Preschool' THEN 1
            WHEN 'School-age' THEN 2
        END;
UPDATE Rates
SET Rates.TimeID =
        CASE Time
            WHEN 'FT' THEN 0
            WHEN 'PT' THEN 1
        END;
UPDATE Rates
SET Rates.RegionId =
        CASE Region
            WHEN 'East' THEN 0
            WHEN 'NorthCentral' THEN 1
            WHEN 'NorthWest' THEN 2
            WHEN 'SouthCentral' THEN 3
            WHEN 'SouthWest' THEN 4
        END;


CREATE TABLE MonthlyEnrollmentReporting (
    -- Maintain all table IDs for future updates
    ChildId uniqueidentifier,
    OrganizationId int,
    OrganizationName nvarchar(100),
    SiteId int,
    SiteName nvarchar(100),
    EnrollmentId int,
    FamilyDeterminationId int,
    FamilyId int,
    ReportingPeriodId int,
    ReportId int,
    Period varchar(25),
    ReportingPeriodStart date,
    ReportingPeriodEnd date,
    -- Used Variables
    Sasid nvarchar(max),
    LastName varchar(250),
    FirstName varchar(250),
    AgeGroupName varchar(50),
    TimeName varchar(5),
    SiteLicenseNumber int,
    RegionName varchar(50),
    TitleI bit,
    Entry date,
    [Exit] date,
    NumberOfPeople int,
    Income int,
    Foster bit,
    Accredited bit,
    Rate decimal (18,2),
    CDCRevenue decimal (18,2),
    FundingSource int,
    SMI75 int,
    FPL200 int,
    Under75SMI bit,
    Under200FPL bit,
    CONSTRAINT MonthlyEnrollment UNIQUE
    (ChildId,
    EnrollmentId, 
    ReportingPeriodId, 
    ReportId,
    FundingSource)
);

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
