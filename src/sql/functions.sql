CREATE FUNCTION CDCMonthlyEnrollmentReporting (@StartDate date, @EndDate date)
    RETURNS TABLE
AS
    RETURN
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
    FDTemp.NumberOfPeople,
    FDTemp.Income,
    Child.Foster,
    Report.Accredited,
    Rates.Rate,
    F.Source,
    CASE WHEN IncomeLevels.x75SMI < FDTemp.Income THEN 1 ELSE 0 END as Under75SMI,
    CASE WHEN IncomeLevels.x200FPL < FDTemp.Income THEN 1 ELSE 0 END as Under200FPL
    from Funding F
    inner join ReportingPeriod RPCDC on RPCDC.Id >= F.FirstReportingPeriodId
                            and (F.LastReportingPeriodId IS NULL or RPCDC.Id < F.LastReportingPeriodId)
    inner join Enrollment on Enrollment.Id = EnrollmentId
    inner join Site on Site.Id = SiteId
    inner join Organization on Site.OrganizationId = Organization.Id
    inner join Child on Child.Id = ChildId
    inner join Family on Child.FamilyId = Family.Id
    LEFT OUTER JOIN Report on Organization.Id = Report.OrganizationId and Report.ReportingPeriodId = RPCDC.Id
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

        from FamilyDetermination
      ) as FDTemp
      on FDTemp.FamilyId = Family.Id and rn = 1
    LEFT JOIN IncomeLevels on FDTemp.NumberOfPeople = IncomeLevels.NumberOfPeople
    WHERE F.Source = 0 and (RPCDC.PeriodStart >= @StartDate and RPCDC.PeriodEnd <= @EndDate);


CREATE FUNCTION CDCMonthlyOrganizationSpaceReporting(@StartDate date, @EndDate date)
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
    count(distinct MER.EnrollmentId) as FilledSpaces,
    sum(MER.Rate) as CDCRevenue
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
    GROUP BY RP.Id, Report.Id, RP.Period, RP.PeriodStart, RP.PeriodEnd, Report.Accredited, Report.Type, o.Id, o.Name, FS.Capacity, NameLookup.Time, NameLookup.AgeGroup;


CREATE FUNCTION CDCMonthlyOrganizationRevenueReporting(@StartDate date, @EndDate date)
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
    sum(MOSR.Capacity) as TotalCapacity,
    sum(MOSR.FilledSpaces) as FilledSpaces
FROM MonthlyOrganizationSpaceReporting MOSR
INNER JOIN Report R on MOSR.ReportId = R.Id
GROUP BY MOSR.ReportingPeriodId, MOSR.ReportId, MOSR.Period, MOSR.ReportingPeriodStart, MOSR.ReportingPeriodEnd, MOSR.Accredited, MOSR.OrganizationId, MOSR.OrganizationName, R.RetroactiveC4KRevenue, R.FamilyFeesRevenue, R.C4KRevenue;