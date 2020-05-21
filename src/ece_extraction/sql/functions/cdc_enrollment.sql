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
    Child.Sasid,
    Child.LastName,
    Child.FirstName,
    Site.TitleI,
    Report.Accredited,
    Enrollment.AgeGroup,
    FS.Time,
    Site.Region,
    Enrollment.AgeGroup,
    Site.LicenseNumber as SiteLicenseNumber,
    Site.TitleI,
    Enrollment.Entry,
    Enrollment.[Exit],
    Child.Foster,
    FDTemp.NumberOfPeople,
    FDTemp.Income,
    Child.AmericanIndianOrAlaskaNative,
	Child.Asian,
	Child.BlackOrAfricanAmerican,
	Child.NativeHawaiianOrPacificIslander,
	Child.White,
	Child.HispanicOrLatinxEthnicity,
	Child.Gender,
    Child.Foster,
    Report.Accredited,
    F.Source,
    C4K.StartDate,
    C4K.EndDate
    from Funding FOR SYSTEM_TIME AS OF :system_time AS F
    inner join ReportingPeriod RPCDC on
        F.FirstReportingPeriodId <= RPCDC.Id and (F.LastReportingPeriodId is null or F.LastReportingPeriodId >= RPCDC.Id)
    inner join Enrollment FOR SYSTEM_TIME AS OF :system_time AS Enrollment on Enrollment.Id = EnrollmentId
    inner join Site on Site.Id = SiteId
    inner join Organization on Site.OrganizationId = Organization.Id
    inner join Child FOR SYSTEM_TIME AS OF :system_time AS Child on Child.Id = ChildId
    inner join Family FOR SYSTEM_TIME AS OF :system_time AS Family on Child.FamilyId = Family.Id
    INNER JOIN Report on Organization.Id = Report.OrganizationId and Report.ReportingPeriodId = RPCDC.Id
    INNER JOIN FundingSpace FS on F.FundingSpaceId = FS.Id
    LEFT OUTER JOIN C4KCertificate as C4K on C4K.ChildId = Child.Id
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

        from FamilyDetermination FOR SYSTEM_TIME AS OF :system_time as FamilyDetermination
      ) as FDTemp
      on FDTemp.FamilyId = Family.Id and rn = 1
    WHERE F.Source = 0 and Report.Id = :report_id