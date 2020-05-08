SET IDENTITY_INSERT Report ON
INSERT INTO dbo.Report (Id, Type, ReportingPeriodId, SubmittedAt, OrganizationId, Accredited, C4KRevenue, RetroactiveC4KRevenue, FamilyFeesRevenue, Comment) VALUES (2292, 0, 10920, dateadd(mi, 10, getdate()), 886, 1, 1234.56, 0, 1000.50, null);
INSERT INTO dbo.Report (Id, Type, ReportingPeriodId, SubmittedAt, OrganizationId, Accredited, C4KRevenue, RetroactiveC4KRevenue, FamilyFeesRevenue, Comment) VALUES (2293, 0, 10921, null, 886, 1, 0.00, 0, null, null);

