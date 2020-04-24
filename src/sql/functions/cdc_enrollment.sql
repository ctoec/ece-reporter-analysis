CREATE FUNCTION CDCMonthlyEnrollmentReporting (@ReportId int)
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
    from Funding F
    inner join ReportingPeriod RPCDC on
        F.FirstReportingPeriodId <= RPCDC.Id and (F.LastReportingPeriodId is null or F.LastReportingPeriodId >= RPCDC.Id)
    inner join Enrollment on Enrollment.Id = EnrollmentId
    inner join Site on Site.Id = SiteId
    inner join Organization on Site.OrganizationId = Organization.Id
    inner join Child on Child.Id = ChildId
    inner join Family on Child.FamilyId = Family.Id
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

        from FamilyDetermination
      ) as FDTemp
      on FDTemp.FamilyId = Family.Id and rn = 1
    LEFT JOIN IncomeLevels on FDTemp.NumberOfPeople = IncomeLevels.NumberOfPeople
    WHERE F.Source = 0 and Report.Id = @ReportId;