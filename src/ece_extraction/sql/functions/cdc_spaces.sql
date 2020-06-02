SELECT
    RP.Id as ReportingPeriodId,
    Report.Id as ReportId,
    o.Id as OrganizationId,
    o.Name as OrganizationName,
    RP.Period,
    RP.PeriodStart,
    RP.PeriodEnd,
    Report.Accredited,
    FS.Capacity,
    FS.Time,
    FS.AgeGroup,
    Report.Type
    FROM Report
    INNER JOIN ReportingPeriod RP on Report.ReportingPeriodId = RP.Id
    INNER JOIN Organization O on Report.OrganizationId = O.Id
    INNER JOIN FundingSpace FS on O.Id = FS.OrganizationId and Report.Type = FS.Source
    WHERE Report.Id = :report_id
