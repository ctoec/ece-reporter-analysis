INSERT INTO MonthlyEnrollmentReporting
select * from CDCMonthlyEnrollmentReporting('2019-11-01', '2020-04-03');

INSERT INTO MonthlyOrganizationSpaceReporting
SELECT * FROM CDCMonthlyOrganizationSpaceReporting('2019-11-01', '2020-04-03');

INSERT INTO MonthlyOrganizationRevenueReporting
SELECT * FROM CDCMonthlyOrganizationRevenueReporting('2019-11-01', '2020-04-03');