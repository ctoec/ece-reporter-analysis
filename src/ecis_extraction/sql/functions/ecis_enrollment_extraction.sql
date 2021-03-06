select
       Student.Student.Id as StudentId,
       Student.Enrollment.Id as EnrollmentId,
       CAST(Student.Enrollment.EnrollmentDate as DATE) as EnrollmentDate,
       CAST(Student.Enrollment.FacilityExitDate as DATE) as FacilityExitDate,
       Universal.Agency.Name,
       Universal.Agency.Id as FacilityId,
       Universal.Agency.Code,
       Universal.Agency.ParentOrganization as OrganizationId,
       Student.Student.SASID,
       Student.StudentDetails.FirstName,
       Student.StudentDetails.MiddleName,
       Student.StudentDetails.LastName,
       Student.StudentDetails.Dob,
       Student.StudentDetails.Gender,
       RecentDetermination.AnnualFamilyIncome,
       RecentDetermination.NumberOfPeopleInHousehold,
       Enrollment.EnrollmentFunding.FundingType,
       RaceList,
       AdditionalFunding.AdditionalFundingTypes,
       trim(concat(RecentAddress.StreetNumber, ' ', RecentAddress.Address1, ' ', RecentAddress.Address2)) as Address,
       RecentAddress.Town,
       RecentAddress.Zip,
       RecentAddress.State,
       RecentDetermination.IndividualizedIEP,
       RecentAddress.AddressType,
       BirthCertificate.Value as BirthCertificateId,
       StateOfBirth.Value as StateOfBirth,
       TownOfBirth.Value as TownOfBirth,
       Enrollment.EnrollmentFunding.SpaceType
FROM Enrollment.EnrollmentFunding
LEFT JOIN Student.Enrollment ON Enrollment.EnrollmentFunding.EnrollmentId = Student.Enrollment.Id
LEFT JOIN Student.Student ON Student.Enrollment.StudentId = Student.Student.Id
left join Student.StudentDetails on Student.Student.Id = Student.StudentDetails.StudentId /* 3 duplicate records */
left join
    (select *, ROW_NUMBER() OVER (PARTITION BY StudentId ORDER BY DateFamilyIncomeDocumented DESC) as RN FROM Enrollment.AdditionalStudentInfo)
    as RecentDetermination on Student.Student.Id = RecentDetermination.StudentId AND RecentDetermination.RN = 1
left join Universal.Agency on Student.Enrollment.FacilityCode = Universal.Agency.Code
LEFT JOIN (select StudentId, string_agg(Student.Race.RaceCode,',') as RaceList
           From Student.Race
           GROUP BY StudentId) as StudentRace on Student.Student.Id = StudentRace.StudentId
left join
    (select *, ROW_NUMBER() OVER (PARTITION BY StudentId ORDER BY ModifiedDate DESC) as RN FROM Student.Address)
        as RecentAddress on Student.Student.Id = RecentAddress.StudentId AND RecentAddress.RN = 1
left join Student.EditableFieldValues as BirthCertificate ON
    BirthCertificate.StudentId = Student.Student.Id AND BirthCertificate.EditableFieldId = 3 and Enrollment.RegisteringSiteId = BirthCertificate.OrganizationId
left join Student.EditableFieldValues as StateOfBirth ON
    StateOfBirth.StudentId = Student.Student.Id AND StateOfBirth.EditableFieldId = 4 and Enrollment.RegisteringSiteId = StateOfBirth.OrganizationId
left join Student.EditableFieldValues as TownOfBirth ON
    Student.Student.Id = TownOfBirth.StudentId AND TownOfBirth.EditableFieldId = 5 and Enrollment.RegisteringSiteId = TownOfBirth.OrganizationId
left join (select EnrollmentId, string_agg(Enrollment.AdditionalFundingSources.AdditionalFundingType,',') as AdditionalFundingTypes
           from Enrollment.AdditionalFundingSources
           GROUP BY EnrollmentId) as AdditionalFunding on AdditionalFunding.EnrollmentId = EnrollmentFunding.EnrollmentId
WHERE StartDate <= CAST(:start_date AS DATETIME) AND EndDate >= CAST(:end_date AS DATETIME)
GROUP BY Student.Student.Id, Student.Enrollment.Id, CAST(Student.Enrollment.EnrollmentDate as DATE), CAST(Student.Enrollment.FacilityExitDate as DATE), Universal.Agency.Name, Universal.Agency.Id, Universal.Agency.Code, Universal.Agency.ParentOrganization, Student.Student.SASID, Student.StudentDetails.FirstName, Student.StudentDetails.MiddleName, Student.StudentDetails.LastName, Student.StudentDetails.Dob, Student.StudentDetails.Gender, RecentDetermination.AnnualFamilyIncome, RecentDetermination.NumberOfPeopleInHousehold, Enrollment.EnrollmentFunding.FundingType, RaceList, AdditionalFunding.AdditionalFundingTypes, trim(concat(RecentAddress.StreetNumber, ' ', RecentAddress.Address1, ' ', RecentAddress.Address2)), RecentAddress.Town, RecentAddress.Zip, RecentAddress.State, RecentDetermination.IndividualizedIEP, RecentAddress.AddressType, BirthCertificate.Value, StateOfBirth.Value, TownOfBirth.Value, Enrollment.EnrollmentFunding.SpaceType;
