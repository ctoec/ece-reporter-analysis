ALTER TABLE Rates ADD RegionId int, AgeGroupID int, TimeID int;
UPDATE Rates
SET Rates.AgeGroupID =
        CASE AgeGroup
            WHEN 'Infant/Toddler' THEN 0
            WHEN 'Preschool' THEN 1
            WHEN 'School-age' THEN 2
        END;
UPDATE Rates
SET Rates.TimeID =
        CASE Time
            WHEN 'FT' THEN 0
            WHEN 'PT' THEN 1
        END;
UPDATE Rates
SET Rates.RegionId =
        CASE Region
            WHEN 'East' THEN 0
            WHEN 'NorthCentral' THEN 1
            WHEN 'NorthWest' THEN 2
            WHEN 'SouthCentral' THEN 3
            WHEN 'SouthWest' THEN 4
        END;


CREATE TABLE MonthlyEnrollmentReporting (
    -- Maintain all table IDs for future updates
    ChildId int,
    OrganizationId int,
    SiteId int,
    EnrollmentId int,
    FamilyDeterminationId int,
    FamilyId int,
    ReportingPeriodId date,
    -- Used Variables
    Sasid int,
    LastName varchar(250),
    FirstName varchar(250),
    AgeGroupName varchar(50),
    TimeName varchar(5),
    SiteLicenseNumber int,
    RegionName varchar(50),
    TitleI bit,
    Entry date,
    [Exit] date,
    NumberOfPeople int,
    Income int,
    Foster bit,
    Accredited bit,
    Rate decimal (18,2),
    Under75SMI bit,
    Under200FPL bit
);