CREATE OR ALTER FUNCTION CDCMonthlyEnrollmentReporting (@ReportId int)
    RETURNS
    @MonthlyEnrollmentsTemp TABLE (ChildId uniqueidentifier,
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
    Under200FPL bit)
AS
BEGIN
DECLARE @SystemTime datetime;
SET @SystemTime = (Select SubmittedAt FROM Report Where Id = @ReportID);
INSERT INTO @MonthlyEnrollmentsTemp
select
    Child.Id as ChildId,
    Organization.Id as OrganizationId,
    Organization.Name as OrganizationName,
    Site.Id as SiteId,
    Site.Name as SiteName,
    Enrollment.Id as EnrollmentId,
    FamilyDeterminationId as FamilyDeterminiationId,
    Family.Id as FamilyId,
    RPCDC.Id as ReportingPeriodId,
    Report.Id as ReportId,
    RPCDC.Period,
    RPCDC.PeriodStart as ReportingPeriodStart,
    RPCDC.PeriodEnd as ReportingPeriodEnd,
    -- Used Variables
    Child.Sasid,
    Child.LastName,
    Child.FirstName,
    Rates.AgeGroup as AgeGroupName,
    Rates.Time as TimeName,
    Site.LicenseNumber as SiteLicenseNumber,
    Rates.Region as RegionName,
    Site.TitleI,
    Enrollment.Entry,
    Enrollment.[Exit],
    CASE WHEN Child.Foster = 1 THEN 1 ELSE FDTemp.NumberOfPeople END as NumberOfPeople,
    CASE WHEN Child.Foster = 1 THEN 0 ELSE FDTemp.Income END as Income,
    Child.Foster,
    Report.Accredited,
    Rates.Rate,
    Rates.Rate * DATEDIFF(week,RPCDC.PeriodStart, RPCDC.PeriodEnd) as CDCRevenue,
    F.Source,
    CASE WHEN Child.Foster = 1 THEN (select x75SMI from IncomeLevels where NumberOfPeople = 1)
         ELSE IncomeLevels.x75SMI
         END as SMI75,
    CASE WHEN Child.Foster = 1 THEN (select x200FPL from IncomeLevels where NumberOfPeople = 1)
         ELSE IncomeLevels.x200FPL
         END as FPL200,
    CASE WHEN Child.Foster = 1 THEN 1
         WHEN FDTemp.Income < IncomeLevels.x75SMI THEN 1
         ELSE 0
         END as Under75SMI,
    CASE WHEN Child.Foster = 1 THEN 1
         WHEN IncomeLevels.x200FPL >= FDTemp.Income THEN 1
         ELSE 0 END as Under200FPL
    from Funding FOR SYSTEM_TIME AS OF @SystemTime AS F
    inner join ReportingPeriod RPCDC on
        F.FirstReportingPeriodId <= RPCDC.Id and (F.LastReportingPeriodId is null or F.LastReportingPeriodId >= RPCDC.Id)
    inner join Enrollment FOR SYSTEM_TIME AS OF @SystemTime AS Enrollment on Enrollment.Id = EnrollmentId
    inner join Site on Site.Id = SiteId
    inner join Organization on Site.OrganizationId = Organization.Id
    inner join Child FOR SYSTEM_TIME AS OF @SystemTime AS Child on Child.Id = ChildId
    inner join Family FOR SYSTEM_TIME AS OF @SystemTime AS Family on Child.FamilyId = Family.Id
    INNER JOIN Report on Organization.Id = Report.OrganizationId and Report.ReportingPeriodId = RPCDC.Id
    LEFT OUTER JOIN Rates on Rates.RegionId = Site.Region and
                             Rates.Accredited = Report.Accredited and
                             Rates.TitleI = Site.TitleI and
                             Rates.AgeGroupID = Enrollment.AgeGroup and
                             Rates.TimeID = F.Time
    left join (
        select
          Id as FamilyDeterminationId,
          FamilyId,
          Income,
          NumberOfPeople,

          row_number() over (
            partition by FamilyId
            order by DeterminationDate desc
          ) as rn

        from FamilyDetermination FOR SYSTEM_TIME AS OF @SystemTime as FamilyDetermination
      ) as FDTemp
      on FDTemp.FamilyId = Family.Id and rn = 1
    LEFT JOIN IncomeLevels on FDTemp.NumberOfPeople = IncomeLevels.NumberOfPeople
    WHERE F.Source = 0 and Report.Id = @ReportId;
RETURN
END

CREATE OR ALTER FUNCTION CDCMonthlyOrganizationSpaceReporting(@ReportId int)
    RETURNS TABLE
AS
    RETURN

SELECT
    RP.Id as ReportingPeriodId,
    Report.Id as ReportId,
    RP.Period,
    RP.PeriodStart as ReportingPeriodStart,
    RP.PeriodEnd as ReportingPeriodEnd,
    Report.Accredited,
    Report.Type as ReportFundingSourceType,
    o.Id as OrganizationId,
    o.Name as OrganizationName,
    FS.Capacity,
    NameLookup.Time as TimeName,
    NameLookup.AgeGroup as AgeGroupName,
    count(MER.EnrollmentId) as UtilizedSpaces,
    sum(case when MER.TitleI = 1 THEN 1 ELSE 0 END) as UtilizedTitleISpaces,
    sum(case when MER.TitleI = 0 THEN 1 ELSE 0 END) as UtilizedNonTitle1Spaces,
    sum(MER.CDCRevenue) as CDCRevenue
    FROM Report
    INNER JOIN ReportingPeriod RP on Report.ReportingPeriodId = RP.Id
    INNER JOIN Organization O on Report.OrganizationId = O.Id
    INNER JOIN FundingSpace FS on O.Id = FS.OrganizationId and Report.Type = FS.Source
    -- Only use rates table to get names of Age Group and Time
    INNER JOIN (select distinct AgeGroup, Time, TimeID, AgeGroupId From Rates) as NameLookup on
                NameLookup.TimeID = FS.Time and NameLookup.AgeGroupID = FS.AgeGroup
    INNER JOIN MonthlyEnrollmentReporting MER on MER.OrganizationId = FS.OrganizationId and
                                                 MER.ReportingPeriodId = RP.Id and
                                                 MER.TimeName = NameLookup.Time and
                                                 MER.AgeGroupName = NameLookup.AgeGroup and
                                                 MER.FundingSource = Report.Type
    WHERE Report.Id = @ReportId
    GROUP BY RP.Id, Report.Id, RP.Period, RP.PeriodStart, RP.PeriodEnd, Report.Accredited, Report.Type, o.Id, o.Name, FS.Capacity, NameLookup.Time, NameLookup.AgeGroup

CREATE OR ALTER FUNCTION CDCMonthlyOrganizationRevenueReporting(@ReportId int)
    RETURNS TABLE
AS
    RETURN
SELECT
    MOSR.ReportingPeriodId,
    MOSR.ReportId,
    MOSR.Period,
    MOSR.ReportingPeriodStart,
    MOSR.ReportingPeriodEnd,
    MOSR.Accredited,
    MOSR.OrganizationId,
    MOSR.OrganizationName,
    R.RetroactiveC4KRevenue,
    R.FamilyFeesRevenue,
    R.C4KRevenue,
    sum(MOSR.CDCRevenue) as CDCRevenue,
    sum(MOSR.Capacity) as TotalCapacity,
    sum(MOSR.UtilizedSpaces) as UtilizedSpaces
    FROM MonthlyOrganizationSpaceReporting MOSR
    INNER JOIN Report R on MOSR.ReportId = R.Id
    WHERE R.Id = @ReportId
    GROUP BY MOSR.ReportingPeriodId, MOSR.ReportId, MOSR.Period, MOSR.ReportingPeriodStart, MOSR.ReportingPeriodEnd, MOSR.Accredited, MOSR.OrganizationId, MOSR.OrganizationName, R.FamilyFeesRevenue, R.C4KRevenue, R.RetroactiveC4KRevenue

