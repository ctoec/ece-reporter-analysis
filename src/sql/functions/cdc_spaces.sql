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
    INNER JOIN FundingTimeAllocation FTA on FS.Id = FTA.FundingSpaceId
    -- Only use rates table to get names of Age Group and Time
    INNER JOIN (select distinct AgeGroup, Time, TimeID, AgeGroupId From Rates) as NameLookup on
                NameLookup.TimeID = FTA.Time and NameLookup.AgeGroupID = FS.AgeGroup
    LEFT OUTER JOIN MonthlyEnrollmentReporting MER on MER.OrganizationId = FS.OrganizationId and
                                                 MER.ReportingPeriodId = RP.Id and
                                                 MER.TimeName = NameLookup.Time and
                                                 MER.AgeGroupName = NameLookup.AgeGroup and
                                                 MER.FundingSource = Report.Type
    WHERE Report.Id = @ReportId
    GROUP BY RP.Id, Report.Id, RP.Period, RP.PeriodStart, RP.PeriodEnd, Report.Accredited, Report.Type, o.Id, o.Name, FS.Capacity, NameLookup.Time, NameLookup.AgeGroup
