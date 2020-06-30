select
    convert(nvarchar(100), Child.Id) as SourceChildId,
    Organization.Id as OrganizationId,
    Organization.Name as OrganizationName,
    Site.Id as SiteId,
    Site.Name as SiteName,
    Site.FacilityCode,
    Enrollment.Id as EnrollmentId,
    FamilyDeterminationId,
    Family.Id as FamilyId,
    Report.Id as ReportId,
    RPCDC.Period,
    RPCDC.PeriodStart,
    RPCDC.PeriodEnd,
    Child.Sasid,
    Child.LastName,
    Child.MiddleName,
    Child.FirstName,
    Child.BirthCertificateId,
    Child.Birthdate,
    Family.Town,
    Family.State,
    Family.Zip,
    trim(CONCAT(AddressLine1,' ', AddressLine2)) as AddressLine,
    Site.TitleI,
    Report.Accredited,
    FS.Time,
    Site.Region,
    Enrollment.AgeGroup,
    Site.LicenseNumber,
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
    F.Source,
    C4K.StartDate,
    C4K.EndDate
    from Funding FOR SYSTEM_TIME AS OF :funding_system_time AS F
    inner join ReportingPeriod RPCDC on
        F.FirstReportingPeriodId <= RPCDC.Id and (F.LastReportingPeriodId is null or F.LastReportingPeriodId >= RPCDC.Id)
    inner join Enrollment FOR SYSTEM_TIME AS OF :system_time AS Enrollment on Enrollment.Id = EnrollmentId
    inner join Site on Site.Id = SiteId
    inner join Organization on Site.OrganizationId = Organization.Id
    inner join Child FOR SYSTEM_TIME AS OF :system_time AS Child on Child.Id = ChildId
    inner join Family FOR SYSTEM_TIME AS OF :system_time AS Family on Child.FamilyId = Family.Id
    INNER JOIN Report on Organization.Id = Report.OrganizationId and Report.ReportingPeriodId = RPCDC.Id
    INNER JOIN FundingSpace FS on F.FundingSpaceId = FS.Id
    LEFT OUTER JOIN C4KCertificate as C4K on C4K.ChildId = Child.Id AND C4K.StartDate <= RPCDC.PeriodEnd AND
                    (C4K.EndDate IS NULL OR C4K.EndDate >= RPCDC.PeriodStart)
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