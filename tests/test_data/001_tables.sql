create schema History
go


create table History.Child
(
	Id uniqueidentifier not null,
	AuthorId int,
	Sasid nvarchar(max),
	FirstName nvarchar(35) not null,
	MiddleName nvarchar(35),
	LastName nvarchar(35) not null,
	Suffix nvarchar(10),
	Birthdate date,
	BirthTown nvarchar(max),
	BirthState nvarchar(max),
	BirthCertificateId nvarchar(max),
	AmericanIndianOrAlaskaNative bit not null,
	Asian bit not null,
	BlackOrAfricanAmerican bit not null,
	NativeHawaiianOrPacificIslander bit not null,
	White bit not null,
	HispanicOrLatinxEthnicity bit,
	Gender int not null,
	Foster bit not null,
	FamilyId int,
	OrganizationId int not null,
	SysStartTime datetime2(0) not null,
	SysEndTime datetime2(0) not null,
	UpdatedAt datetime2,
	C4KFamilyCaseNumber int
)
go

create clustered index ix_Child
	on History.Child (SysStartTime, SysEndTime)
go

create table History.Enrollment
(
	Id int not null,
	AuthorId int,
	ChildId uniqueidentifier not null,
	SiteId int not null,
	AgeGroup int,
	Entry date,
	[Exit] date,
	ExitReason nvarchar(max),
	SysStartTime datetime2(0) not null,
	SysEndTime datetime2(0) not null,
	UpdatedAt datetime2
)
go

create clustered index ix_Enrollment
	on History.Enrollment (SysStartTime, SysEndTime)
go

create table History.Family
(
	Id int not null,
	AuthorId int,
	AddressLine1 nvarchar(max),
	AddressLine2 nvarchar(max),
	Town nvarchar(max),
	State nvarchar(max),
	Zip nvarchar(max),
	Homelessness bit not null,
	OrganizationId int not null,
	SysStartTime datetime2(0) not null,
	SysEndTime datetime2(0) not null,
	UpdatedAt datetime2
)
go

create clustered index ix_Family
	on History.Family (SysStartTime, SysEndTime)
go

create table History.FamilyDetermination
(
	Id int not null,
	AuthorId int,
	NotDisclosed bit not null,
	NumberOfPeople int,
	Income decimal(14,2),
	DeterminationDate date,
	FamilyId int not null,
	SysStartTime datetime2(0) not null,
	SysEndTime datetime2(0) not null,
	UpdatedAt datetime2
)
go

create clustered index ix_FamilyDetermination
	on History.FamilyDetermination (SysStartTime, SysEndTime)
go

create table History.Funding
(
	Id int not null,
	AuthorId int,
	EnrollmentId int not null,
	Source int,
	FirstReportingPeriodId int,
	LastReportingPeriodId int,
	SysStartTime datetime2(0) not null,
	SysEndTime datetime2(0) not null,
	UpdatedAt datetime2,
	FundingSpaceId int
)
go

create clustered index ix_Funding
	on History.Funding (SysStartTime, SysEndTime)
go

create table Organization
(
	Id int identity
		constraint PK_Organization
			primary key,
	Name nvarchar(100) not null
)
go

create table FundingSpace
(
	Id int identity
		constraint PK_FundingSpace
			primary key,
	Capacity int not null,
	OrganizationId int not null
		constraint FK_FundingSpace_Organization_OrganizationId
			references Organization,
	Source int not null,
	AgeGroup int not null,
	Time int not null
)
go

create index IX_FundingSpace_OrganizationId
	on FundingSpace (OrganizationId)
go



create table FundingTimeSplit
(
	Id int identity
		constraint PK_FundingTimeSplit
			primary key,
	FundingSpaceId int not null
		constraint FK_FundingTimeSplit_FundingSpace_FundingSpaceId
			references FundingSpace
				on delete cascade,
	FullTimeWeeks int not null,
	PartTimeWeeks int not null
)
go

create unique index IX_FundingTimeSplit_FundingSpaceId
	on FundingTimeSplit (FundingSpaceId)
go


create table ReportingPeriod
(
	Id int identity
		constraint PK_ReportingPeriod
			primary key,
	Type int not null,
	Period date not null,
	PeriodStart date not null,
	PeriodEnd date not null,
	DueAt date not null
)
go

create table Report
(
	Id int identity
		constraint PK_Report
			primary key,
	Type int not null,
	ReportingPeriodId int not null
		constraint FK_Report_ReportingPeriod_ReportingPeriodId
			references ReportingPeriod,
	SubmittedAt datetime2,
	OrganizationId int
		constraint FK_Report_Organization_OrganizationId
			references Organization,
	Accredited bit,
	C4KRevenue decimal(18,2),
	RetroactiveC4KRevenue bit,
	FamilyFeesRevenue decimal(18,2),
	Comment nvarchar(max)
)
go

create index IX_Report_OrganizationId
	on Report (OrganizationId)
go

create index IX_Report_ReportingPeriodId
	on Report (ReportingPeriodId)
go

create table Site
(
	Id int identity
		constraint PK_Site
			primary key,
	Name nvarchar(100) not null,
	TitleI bit not null,
	Region int not null,
	OrganizationId int not null
		constraint FK_Site_Organization_OrganizationId
			references Organization,
	FacilityCode int,
	LicenseNumber int,
	NaeycId int,
	RegistryId int
)
go

create index IX_Site_OrganizationId
	on Site (OrganizationId)
go

create table [User]
(
	Id int identity
		constraint PK_User
			primary key,
	WingedKeysId uniqueidentifier not null,
	FirstName nvarchar(35) not null,
	MiddleName nvarchar(35),
	LastName nvarchar(35) not null,
	Suffix nvarchar(10)
)
go

create table Family
(
	Id int identity
		constraint PK_Family
			primary key,
	AuthorId int
		constraint FK_Family_User_AuthorId
			references [User],
	AddressLine1 nvarchar(max),
	AddressLine2 nvarchar(max),
	Town nvarchar(max),
	State nvarchar(max),
	Zip nvarchar(max),
	Homelessness bit not null,
	OrganizationId int not null
		constraint FK_Family_Organization_OrganizationId
			references Organization,
	SysStartTime datetime2(0) GENERATED ALWAYS AS ROW START constraint Family_SysStart default sysutcdatetime()  not null,
	SysEndTime datetime2(0) GENERATED ALWAYS AS ROW END constraint Family_SysEnd default CONVERT([datetime2](0),'9999-12-31 23:59:59') not null,
	UpdatedAt datetime2,
	PERIOD FOR SYSTEM_TIME (SysStartTime, SysEndTime)
) WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = History.Family))
go

create table Child
(
	Id uniqueidentifier not null
		constraint PK_Child
			primary key,
	AuthorId int
		constraint FK_Child_User_AuthorId
			references [User],
	Sasid nvarchar(max),
	FirstName nvarchar(35) not null,
	MiddleName nvarchar(35),
	LastName nvarchar(35) not null,
	Suffix nvarchar(10),
	Birthdate date,
	BirthTown nvarchar(max),
	BirthState nvarchar(max),
	BirthCertificateId nvarchar(max),
	AmericanIndianOrAlaskaNative bit not null,
	Asian bit not null,
	BlackOrAfricanAmerican bit not null,
	NativeHawaiianOrPacificIslander bit not null,
	White bit not null,
	HispanicOrLatinxEthnicity bit,
	Gender int not null,
	Foster bit not null,
	FamilyId int
		constraint FK_Child_Family_FamilyId
			references Family,
	OrganizationId int not null
		constraint FK_Child_Organization_OrganizationId
			references Organization,
	SysStartTime datetime2(0) GENERATED ALWAYS AS ROW START constraint Child_SysStart default sysutcdatetime() not null,
	SysEndTime datetime2(0) GENERATED ALWAYS AS ROW END constraint Child_SysEnd default CONVERT([datetime2](0),'9999-12-31 23:59:59') not null,
	UpdatedAt datetime2,
	C4KFamilyCaseNumber int,
	PERIOD FOR SYSTEM_TIME (SysStartTime, SysEndTime)
) WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = History.Child))
go

create table C4KCertificate
(
	Id int identity
		constraint PK_C4KCertificate
			primary key,
	ChildId uniqueidentifier not null,
	StartDate datetime2,
	EndDate datetime2
)
go

create index IX_C4KCertificate_ChildId
	on C4KCertificate (ChildId)
go

create index IX_Child_AuthorId
	on Child (AuthorId)
go

create index IX_Child_FamilyId
	on Child (FamilyId)
go

create index IX_Child_OrganizationId
	on Child (OrganizationId)
go

create table Enrollment
(
	Id int identity
		constraint PK_Enrollment
			primary key,
	AuthorId int,
	ChildId uniqueidentifier not null
		constraint FK_Enrollment_Child_ChildId
			references Child,
	SiteId int not null
		constraint FK_Enrollment_Site_SiteId
			references Site,
	AgeGroup int,
	Entry date,
	[Exit] date,
	ExitReason nvarchar(max),
	SysStartTime datetime2(0) GENERATED ALWAYS AS ROW START constraint Enrollment_SysStart default sysutcdatetime() not null,
	SysEndTime datetime2(0) GENERATED ALWAYS AS ROW END constraint Enrollment_SysEnd default CONVERT([datetime2](0),'9999-12-31 23:59:59') not null,
	UpdatedAt datetime2,
	PERIOD FOR SYSTEM_TIME (SysStartTime, SysEndTime)
) WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = History.Enrollment))
go

create index IX_Enrollment_AuthorId
	on Enrollment (AuthorId)
go

create index IX_Enrollment_ChildId
	on Enrollment (ChildId)
go

create index IX_Enrollment_SiteId
	on Enrollment (SiteId)
go

create index IX_Family_AuthorId
	on Family (AuthorId)
go

create index IX_Family_OrganizationId
	on Family (OrganizationId)
go

create table FamilyDetermination
(
	Id int identity
		constraint PK_FamilyDetermination
			primary key,
	AuthorId int
		constraint FK_FamilyDetermination_User_AuthorId
			references [User],
	NotDisclosed bit not null,
	NumberOfPeople int,
	Income decimal(14,2),
	DeterminationDate date,
	FamilyId int not null
		constraint FK_FamilyDetermination_Family_FamilyId
			references Family,
	SysStartTime datetime2(0) GENERATED ALWAYS AS ROW START constraint FamilyDetermination_SysStart default sysutcdatetime() not null,
	SysEndTime datetime2(0) GENERATED ALWAYS AS ROW END constraint FamilyDetermination_SysEnd default CONVERT([datetime2](0),'9999-12-31 23:59:59') not null,
	UpdatedAt datetime2,
	PERIOD FOR SYSTEM_TIME (SysStartTime, SysEndTime)
) WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = History.FamilyDetermination))
go

create index IX_FamilyDetermination_AuthorId
	on FamilyDetermination (AuthorId)
go

create index IX_FamilyDetermination_FamilyId
	on FamilyDetermination (FamilyId)
go

create table Funding
(
	Id int identity
		constraint PK_Funding
			primary key,
	AuthorId int,
	EnrollmentId int not null
		constraint FK_Funding_Enrollment_EnrollmentId
			references Enrollment
				on delete cascade,
	Source int,
	FirstReportingPeriodId int
		constraint FK_Funding_ReportingPeriod_FirstReportingPeriodId
			references ReportingPeriod,
	LastReportingPeriodId int
		constraint FK_Funding_ReportingPeriod_LastReportingPeriodId
			references ReportingPeriod,
	SysStartTime datetime2(0) GENERATED ALWAYS AS ROW START constraint Funding_SysStart default sysutcdatetime() not null,
	SysEndTime datetime2(0) GENERATED ALWAYS AS ROW END constraint Funding_SysEnd default CONVERT([datetime2](0),'9999-12-31 23:59:59') not null,
	UpdatedAt datetime2,
	FundingSpaceId int
		constraint FK_Funding_FundingSpace_FundingSpaceId
			references FundingSpace,
	PERIOD FOR SYSTEM_TIME (SysStartTime, SysEndTime)
) WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = History.Funding))
go

create index IX_Funding_AuthorId
	on Funding (AuthorId)
go

create index IX_Funding_EnrollmentId
	on Funding (EnrollmentId)
go

create index IX_Funding_FirstReportingPeriodId
	on Funding (FirstReportingPeriodId)
go

create index IX_Funding_LastReportingPeriodId
	on Funding (LastReportingPeriodId)
go

create index IX_Funding_FundingSpaceId
	on Funding (FundingSpaceId)
go

create table Rates
(
    Accredited bit,
    TitleI     bit,
    Region     varchar(max),
    AgeGroup   varchar(max),
    Time       varchar(max),
    Rate       float,
    RegionId   int,
    AgeGroupID int,
    TimeID     int
)
go

create table IncomeLevels
(
    NumberOfPeople int,
    x75SMI         int,
    x200FPL        int
)
go

create table __EFMigrationsHistory
(
	MigrationId nvarchar(150) not null
		constraint PK___EFMigrationsHistory
			primary key,
	ProductVersion nvarchar(32) not null
)
go

