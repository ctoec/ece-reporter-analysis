-- Empty all tables
DELETE FROM MonthlyEnrollmentReporting;
DELETE FROM MonthlyOrganizationSpaceReporting;
DELETE FROM MonthlyOrganizationRevenueReporting;

-- Reload tables from all reports currently in the database
DECLARE @MyCursor CURSOR;
DECLARE @ReportId int;
BEGIN
    SET @MyCursor = CURSOR FOR
    select Id from Report WHERE SubmittedAt IS NOT NULL

    OPEN @MyCursor
    FETCH NEXT FROM @MyCursor
    INTO @ReportId

    WHILE @@FETCH_STATUS = 0
    BEGIN
        INSERT INTO MonthlyEnrollmentReporting
        select * from CDCMonthlyEnrollmentReporting(@ReportId);
        INSERT INTO MonthlyOrganizationSpaceReporting
        SELECT * FROM CDCMonthlyOrganizationSpaceReporting(@ReportId);
        INSERT INTO MonthlyOrganizationRevenueReporting
        select * from CDCMonthlyOrganizationRevenueReporting(@ReportId);
      FETCH NEXT FROM @MyCursor
      INTO @ReportId
    END;

    CLOSE @MyCursor ;
    DEALLOCATE @MyCursor;
END;