-- Create Enrollment Table
IF NOT EXISTS (select *
from INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME = 'MonthlyEnrollmentReporting'
  AND TABLE_SCHEMA = 'dbo')

BEGIN
    create table dbo.MonthlyEnrollmentReporting
(
	Id int identity
		primary key,
	SourceSystem varchar(100),
	SourceChildId varchar(100),
	Sasid varchar(max),
	FirstName varchar(250),
	MiddleName varchar(250),
	LastName varchar(250),
	BirthCertificateId varchar(max),
	BirthDate datetime,
	Town varchar(max),
	ZipCode varchar(max),
	State varchar(max),
	CombinedAddress varchar(max),
	StateOfBirth varchar(10),
	TownOfBirth varchar(max),
	FamilySize int,
	Income numeric(18),
	AmericanIndianOrAlaskaNative bit,
	Asian bit,
	BlackOrAfricanAmerican bit,
	NativeHawaiianOrPacificIslander bit,
	White bit,
	TwoOrMoreRaces bit,
	HispanicOrLatinxEthnicity bit,
	Gender varchar(25),
	Foster bit,
	HasIEP bit,
	CDCAgeGroupName varchar(50),
	CDCTimeName varchar(50),
	EnrollmentId int,
	FamilyDeterminationId int,
	FamilyId int,
	SourceOrganizationId int,
	OrganizationName varchar(100),
	SourceSiteId int,
	SiteName varchar(100),
	FacilityCode int,
	SpaceType varchar(50),
	SpaceTypeSubcategory varchar(100),
	SiteLicenseNumber int,
	RegionName varchar(50),
	TitleI bit,
	Entry datetime,
	[Exit] datetime,
	Accredited bit,
	Rate decimal(18,2),
	CDCRevenue decimal(18,2),
	FundingSource varchar(50),
	SMI75 int,
	FPL200 int,
	Under75SMI bit,
	Under200FPL bit,
	ActiveC4K bit,
	ReportId int,
	Period datetime,
	PeriodType varchar(25),
	PeriodStart datetime,
	PeriodEnd datetime,
	TimeInserted datetime default current_timestamp,
	TimeUpdated datetime default current_timestamp,
    UNIQUE(SourceChildId, EnrollmentId, Period, PeriodType, FundingSource)
);
END
go

-- Create space table
IF NOT EXISTS (select *
from INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME = 'MonthlyOrganizationSpaceReporting'
  AND TABLE_SCHEMA = 'dbo')

BEGIN
    create table dbo.MonthlyOrganizationSpaceReporting
    (
        Id int identity
            primary key,
        ReportId int,
        Period varchar(25),
        PeriodType varchar(25),
        PeriodStart datetime,
        PeriodEnd datetime,
        ReportFundingSourceType varchar(50),
        SourceOrganizationId int,
        OrganizationName varchar(200),
        Capacity int,
        CDCTimeName varchar(20),
        CDCAgeGroupName varchar(20),
        Accredited bit,
        SpaceType varchar(50),
        UtilizedSpaces int,
        UtilizedTitleISpaces int,
        UtilizedNonTitle1Spaces int,
        CDCRevenue decimal(18,2),
        TimeInserted datetime default current_timestamp,
        TimeUpdated datetime default current_timestamp,
        UNIQUE(Period, PeriodType, SourceOrganizationId, ReportFundingSourceType, SpaceType)
    )
END
go

-- Create Revenue table
IF NOT EXISTS (select *
from INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME = 'MonthlyOrganizationRevenueReporting'
  AND TABLE_SCHEMA = 'dbo')
BEGIN
    create table dbo.MonthlyOrganizationRevenueReporting
    (
        Id int identity
            primary key,
        ReportId int,
        Period datetime,
        PeriodType varchar(25),
        SourceOrganizationId int,
        OrganizationName varchar(max),
        PeriodStart datetime,
        PeriodEnd datetime,
        Accredited bit,
        RetroactiveC4KRevenue bit,
        FamilyFeesRevenue decimal(18,2),
        C4KRevenue decimal(18,2),
        CDCRevenue decimal(18,2),
        TotalCapacity int,
        UtilizedSpaces int,
        ReportFundingSourceType varchar(50),
        TimeInserted datetime default current_timestamp,
        TimeUpdated datetime default current_timestamp,
        UNIQUE(Period, PeriodType, SourceOrganizationId, ReportFundingSourceType)
    )
END
go

-- Create triggers for time updated columns
DROP TRIGGER IF EXISTS dbo.TriggerEnrollmentTsUpd;
go
CREATE TRIGGER dbo.TriggerEnrollmentTsUpd ON dbo.MonthlyEnrollmentReporting
        AFTER UPDATE
        AS
          UPDATE e set TimeUpdated=GETDATE()
          FROM
          dbo.MonthlyEnrollmentReporting AS e
          INNER JOIN inserted
          AS i
          ON e.Id = i.Id;
go

DROP TRIGGER IF EXISTS dbo.TriggerSpaceTsUpd;
go
CREATE TRIGGER dbo.TriggerSpaceTsUpd ON dbo.MonthlyOrganizationSpaceReporting
        AFTER UPDATE
        AS
          UPDATE s set TimeUpdated=GETDATE()
          FROM
          dbo.MonthlyOrganizationSpaceReporting AS s
          INNER JOIN inserted
          AS i
          ON s.Id = i.Id;
go

DROP TRIGGER IF EXISTS dbo.TriggerOrgRevTsUpd;
go
CREATE TRIGGER dbo.TriggerOrgRevTsUpd ON dbo.MonthlyOrganizationRevenueReporting
        AFTER UPDATE
        AS
          UPDATE r set TimeUpdated=GETDATE()
          FROM
          dbo.MonthlyOrganizationRevenueReporting AS r
          INNER JOIN inserted
          AS i
          ON r.Id = i.Id;
go

