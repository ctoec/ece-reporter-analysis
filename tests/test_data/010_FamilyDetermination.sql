SET IDENTITY_INSERT FamilyDetermination ON
INSERT INTO dbo.FamilyDetermination (Id, AuthorId, NotDisclosed, NumberOfPeople, Income, DeterminationDate, FamilyId, UpdatedAt) VALUES (17710, null, 0, 3, null, N'2019-08-01', 18238, N'2020-04-22 13:27:05.3879473');
INSERT INTO dbo.FamilyDetermination (Id, AuthorId, NotDisclosed, NumberOfPeople, Income, DeterminationDate, FamilyId, UpdatedAt) VALUES (17711, null, 0, 3, 20000.00, N'2019-08-01', 18239, N'2020-04-22 13:27:05.4670624');
INSERT INTO dbo.FamilyDetermination (Id, AuthorId, NotDisclosed, NumberOfPeople, Income, DeterminationDate, FamilyId, UpdatedAt) VALUES (17712, null, 0, 3, 20000.00, N'2019-08-01', 18240, N'2020-04-22 13:27:05.5083174');
INSERT INTO dbo.FamilyDetermination (Id, AuthorId, NotDisclosed, NumberOfPeople, Income, DeterminationDate, FamilyId, UpdatedAt) VALUES (17713, null, 0, 2, 70000.00, N'2019-08-01', 18241, N'2020-04-22 13:27:05.5429573');
INSERT INTO dbo.FamilyDetermination (Id, AuthorId, NotDisclosed, NumberOfPeople, Income, DeterminationDate, FamilyId, UpdatedAt) VALUES (17714, null, 0, 9, 20000.00, N'2019-08-01', 18242, N'2020-04-22 13:27:05.6249209');
INSERT INTO dbo.FamilyDetermination (Id, AuthorId, NotDisclosed, NumberOfPeople, Income, DeterminationDate, FamilyId, UpdatedAt) VALUES (17715, null, 0, 3, 20000.00, N'2019-08-01', 18243, N'2020-04-22 13:27:05.6887436');
-- Check that multiple determinations is processed correctly
INSERT INTO dbo.FamilyDetermination (Id, AuthorId, NotDisclosed, NumberOfPeople, Income, DeterminationDate, FamilyId, UpdatedAt) VALUES (17716, null, 0, 3, 20000.00, N'2019-08-01', 18244, N'2020-04-22 13:27:05.7358267');
INSERT INTO dbo.FamilyDetermination (Id, AuthorId, NotDisclosed, NumberOfPeople, Income, DeterminationDate, FamilyId, UpdatedAt) VALUES (17717, null, 0, 4, 10000.00, N'2019-08-02', 18244, N'2020-04-22 13:28:05.7358267');
-- Check less than logic for income
INSERT INTO dbo.FamilyDetermination (Id, AuthorId, NotDisclosed, NumberOfPeople, Income, DeterminationDate, FamilyId, UpdatedAt) VALUES (17720, null, 0, 8, 84761.00, N'2019-08-01', 18248, N'2020-04-22 13:27:05.9619081');
INSERT INTO dbo.FamilyDetermination (Id, AuthorId, NotDisclosed, NumberOfPeople, Income, DeterminationDate, FamilyId, UpdatedAt) VALUES (17721, null, 0, 5, 58839.00, N'2019-08-01', 18245, N'2020-04-22 13:27:06.0517533');
INSERT INTO dbo.FamilyDetermination (Id, AuthorId, NotDisclosed, NumberOfPeople, Income, DeterminationDate, FamilyId, UpdatedAt) VALUES (17722, null, 0, 3, 20000.00, N'2019-08-01', 18246, N'2020-04-22 13:27:06.1017757');
INSERT INTO dbo.FamilyDetermination (Id, AuthorId, NotDisclosed, NumberOfPeople, Income, DeterminationDate, FamilyId, UpdatedAt) VALUES (17729, null, 0, 3, 20000.00, N'2019-08-01', 18257, N'2020-04-22 13:27:06.4908938');
INSERT INTO dbo.FamilyDetermination (Id, AuthorId, NotDisclosed, NumberOfPeople, Income, DeterminationDate, FamilyId, UpdatedAt) VALUES (17735, null, 0, 3, 20000.00, N'2019-08-01', 18263, N'2020-04-22 13:27:06.8605111');
INSERT INTO dbo.FamilyDetermination (Id, AuthorId, NotDisclosed, NumberOfPeople, Income, DeterminationDate, FamilyId, UpdatedAt) VALUES (17744, null, 0, 3, 20000.00, N'2019-08-01', 18272, N'2020-04-22 13:27:07.5004972');
INSERT INTO dbo.FamilyDetermination (Id, AuthorId, NotDisclosed, NumberOfPeople, Income, DeterminationDate, FamilyId, UpdatedAt) VALUES (17746, null, 0, 3, 20000.00, N'2019-08-01', 18274, N'2020-04-22 13:27:07.6683711');
