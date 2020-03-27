select
      Child.Id as ChildId,
      Site.Id as SiteId,
      Family.Id as FamilyId,
      FamilyDeterminationID,
      Enrollment.Id as EnrollmentId,
      RP.Id as ReportingPeriodId,
      Report.Id as ReportId,
      Rates.Rate
    from Funding F
        -- TODO Replace constant date with variable date for backfilling
    inner join ReportingPeriod RP on RP.Id >= F.FirstReportingPeriodId
                            and (F.LastReportingPeriodId IS NULL or RP.Id < F.LastReportingPeriodId)
                            and (RP.PeriodStart <= '2019-12-02' and RP.PeriodEnd >= '2019-12-02')
    inner join Enrollment on Enrollment.Id = EnrollmentId
    inner join Site on Site.Id = SiteId
    inner join Organization on Site.OrganizationId = Organization.Id
    inner join Child on Child.Id = ChildId
    inner join Family on Child.FamilyId = Family.Id
    LEFT OUTER JOIN Report on Organization.Id = Report.OrganizationId and Report.ReportingPeriodId = RP.Id
    LEFT OUTER JOIN Rates on Rates.RegionId = Site.Region and
                             Rates.Accredited = Report.Accredited and
                             Rates.TitleI = Site.TitleI and
                             Rates.AgeGroupID = Enrollment.AgeGroup and
                             Rates.TimeID = F.Time
    left join (
        select
          Id as FamilyDeterminationID,
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