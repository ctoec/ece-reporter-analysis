create table FamilyDetermination
(
    Id                int identity
        constraint PK_FamilyDetermination
            primary key,
    AuthorId          int,
    NotDisclosed      bit                                                                            not null,
    NumberOfPeople    int,
    Income            decimal(14, 2),
    DeterminationDate date,
    FamilyId          int,
    SysStartTime      datetime2(0)
        constraint FamilyDetermination_SysStart default sysutcdatetime()                             not null,
    SysEndTime        datetime2(0)
        constraint FamilyDetermination_SysEnd default CONVERT([datetime2](0), '9999-12-31 23:59:59') not null,
    UpdatedAt         datetime2
)
go
SET IDENTITY_INSERT FamilyDetermination ON
create index IX_FamilyDetermination_AuthorId
    on FamilyDetermination (AuthorId)
go

create index IX_FamilyDetermination_FamilyId
    on FamilyDetermination (FamilyId)
go

INSERT INTO dbo.FamilyDetermination (Id, AuthorId, NotDisclosed, NumberOfPeople, Income, DeterminationDate, FamilyId, UpdatedAt) VALUES (17710, null, 0, 3, null, N'2019-08-01', 18238, N'2020-04-22 13:27:05.3879473');
INSERT INTO dbo.FamilyDetermination (Id, AuthorId, NotDisclosed, NumberOfPeople, Income, DeterminationDate, FamilyId, UpdatedAt) VALUES (17711, null, 0, 3, 20000.00, N'2019-08-01', 18239, N'2020-04-22 13:27:05.4670624');
INSERT INTO dbo.FamilyDetermination (Id, AuthorId, NotDisclosed, NumberOfPeople, Income, DeterminationDate, FamilyId, UpdatedAt) VALUES (17712, null, 0, 3, 20000.00, N'2019-08-01', 18240, N'2020-04-22 13:27:05.5083174');
INSERT INTO dbo.FamilyDetermination (Id, AuthorId, NotDisclosed, NumberOfPeople, Income, DeterminationDate, FamilyId, UpdatedAt) VALUES (17713, null, 0, 3, 20000.00, N'2019-08-01', 18241, N'2020-04-22 13:27:05.5429573');
INSERT INTO dbo.FamilyDetermination (Id, AuthorId, NotDisclosed, NumberOfPeople, Income, DeterminationDate, FamilyId, UpdatedAt) VALUES (17714, null, 0, 3, 20000.00, N'2019-08-01', 18242, N'2020-04-22 13:27:05.6249209');
INSERT INTO dbo.FamilyDetermination (Id, AuthorId, NotDisclosed, NumberOfPeople, Income, DeterminationDate, FamilyId, UpdatedAt) VALUES (17715, null, 0, 3, 20000.00, N'2019-08-01', 18243, N'2020-04-22 13:27:05.6887436');
INSERT INTO dbo.FamilyDetermination (Id, AuthorId, NotDisclosed, NumberOfPeople, Income, DeterminationDate, FamilyId, UpdatedAt) VALUES (17716, null, 0, 3, 20000.00, N'2019-08-01', 18244, N'2020-04-22 13:27:05.7358267');
INSERT INTO dbo.FamilyDetermination (Id, AuthorId, NotDisclosed, NumberOfPeople, Income, DeterminationDate, FamilyId, UpdatedAt) VALUES (17717, null, 0, 3, 20000.00, N'2019-08-01', 18245, N'2020-04-22 13:27:05.8037277');
INSERT INTO dbo.FamilyDetermination (Id, AuthorId, NotDisclosed, NumberOfPeople, Income, DeterminationDate, FamilyId, UpdatedAt) VALUES (17718, null, 0, 3, 20000.00, N'2019-08-01', 18246, N'2020-04-22 13:27:05.8549612');
INSERT INTO dbo.FamilyDetermination (Id, AuthorId, NotDisclosed, NumberOfPeople, Income, DeterminationDate, FamilyId, UpdatedAt) VALUES (17719, null, 0, 3, 20000.00, N'2019-08-01', 18247, N'2020-04-22 13:27:05.9119299');
INSERT INTO dbo.FamilyDetermination (Id, AuthorId, NotDisclosed, NumberOfPeople, Income, DeterminationDate, FamilyId, UpdatedAt) VALUES (17720, null, 0, 3, 20000.00, N'2019-08-01', 18248, N'2020-04-22 13:27:05.9619081');
INSERT INTO dbo.FamilyDetermination (Id, AuthorId, NotDisclosed, NumberOfPeople, Income, DeterminationDate, FamilyId, UpdatedAt) VALUES (17721, null, 0, 3, 20000.00, N'2019-08-01', 18249, N'2020-04-22 13:27:06.0517533');
INSERT INTO dbo.FamilyDetermination (Id, AuthorId, NotDisclosed, NumberOfPeople, Income, DeterminationDate, FamilyId, UpdatedAt) VALUES (17722, null, 0, 3, 20000.00, N'2019-08-01', 18250, N'2020-04-22 13:27:06.1017757');
INSERT INTO dbo.FamilyDetermination (Id, AuthorId, NotDisclosed, NumberOfPeople, Income, DeterminationDate, FamilyId, UpdatedAt) VALUES (17723, null, 0, 3, 20000.00, N'2019-08-01', 18251, N'2020-04-22 13:27:06.1600188');
INSERT INTO dbo.FamilyDetermination (Id, AuthorId, NotDisclosed, NumberOfPeople, Income, DeterminationDate, FamilyId, UpdatedAt) VALUES (17724, null, 0, 3, 20000.00, N'2019-08-01', 18252, N'2020-04-22 13:27:06.2342316');
INSERT INTO dbo.FamilyDetermination (Id, AuthorId, NotDisclosed, NumberOfPeople, Income, DeterminationDate, FamilyId, UpdatedAt) VALUES (17725, null, 0, 3, 20000.00, N'2019-08-01', 18253, N'2020-04-22 13:27:06.2863021');
INSERT INTO dbo.FamilyDetermination (Id, AuthorId, NotDisclosed, NumberOfPeople, Income, DeterminationDate, FamilyId, UpdatedAt) VALUES (17726, null, 0, 3, 20000.00, N'2019-08-01', 18254, N'2020-04-22 13:27:06.3283300');
INSERT INTO dbo.FamilyDetermination (Id, AuthorId, NotDisclosed, NumberOfPeople, Income, DeterminationDate, FamilyId, UpdatedAt) VALUES (17727, null, 0, 3, 20000.00, N'2019-08-01', 18255, N'2020-04-22 13:27:06.3815324');
INSERT INTO dbo.FamilyDetermination (Id, AuthorId, NotDisclosed, NumberOfPeople, Income, DeterminationDate, FamilyId, UpdatedAt) VALUES (17728, null, 0, 3, 20000.00, N'2019-08-01', 18256, N'2020-04-22 13:27:06.4356036');
INSERT INTO dbo.FamilyDetermination (Id, AuthorId, NotDisclosed, NumberOfPeople, Income, DeterminationDate, FamilyId, UpdatedAt) VALUES (17729, null, 0, 3, 20000.00, N'2019-08-01', 18257, N'2020-04-22 13:27:06.4908938');
INSERT INTO dbo.FamilyDetermination (Id, AuthorId, NotDisclosed, NumberOfPeople, Income, DeterminationDate, FamilyId, UpdatedAt) VALUES (17730, null, 0, 3, 20000.00, N'2019-08-01', 18258, N'2020-04-22 13:27:06.5625908');
INSERT INTO dbo.FamilyDetermination (Id, AuthorId, NotDisclosed, NumberOfPeople, Income, DeterminationDate, FamilyId, UpdatedAt) VALUES (17731, null, 0, 3, 20000.00, N'2019-08-01', 18259, N'2020-04-22 13:27:06.6145646');
INSERT INTO dbo.FamilyDetermination (Id, AuthorId, NotDisclosed, NumberOfPeople, Income, DeterminationDate, FamilyId, UpdatedAt) VALUES (17732, null, 0, 3, 20000.00, N'2019-08-01', 18260, N'2020-04-22 13:27:06.6689559');
INSERT INTO dbo.FamilyDetermination (Id, AuthorId, NotDisclosed, NumberOfPeople, Income, DeterminationDate, FamilyId, UpdatedAt) VALUES (17733, null, 0, 3, 20000.00, N'2019-08-01', 18261, N'2020-04-22 13:27:06.7262096');
INSERT INTO dbo.FamilyDetermination (Id, AuthorId, NotDisclosed, NumberOfPeople, Income, DeterminationDate, FamilyId, UpdatedAt) VALUES (17734, null, 0, 3, 20000.00, N'2019-08-01', 18262, N'2020-04-22 13:27:06.7870714');
INSERT INTO dbo.FamilyDetermination (Id, AuthorId, NotDisclosed, NumberOfPeople, Income, DeterminationDate, FamilyId, UpdatedAt) VALUES (17735, null, 0, 3, 20000.00, N'2019-08-01', 18263, N'2020-04-22 13:27:06.8605111');
INSERT INTO dbo.FamilyDetermination (Id, AuthorId, NotDisclosed, NumberOfPeople, Income, DeterminationDate, FamilyId, UpdatedAt) VALUES (17736, null, 0, 3, 20000.00, N'2019-08-01', 18264, N'2020-04-22 13:27:06.9467856');
INSERT INTO dbo.FamilyDetermination (Id, AuthorId, NotDisclosed, NumberOfPeople, Income, DeterminationDate, FamilyId, UpdatedAt) VALUES (17737, null, 0, 3, 20000.00, N'2019-08-01', 18265, N'2020-04-22 13:27:07.0144654');
INSERT INTO dbo.FamilyDetermination (Id, AuthorId, NotDisclosed, NumberOfPeople, Income, DeterminationDate, FamilyId, UpdatedAt) VALUES (17738, null, 0, 3, 20000.00, N'2019-08-01', 18266, N'2020-04-22 13:27:07.0794864');
INSERT INTO dbo.FamilyDetermination (Id, AuthorId, NotDisclosed, NumberOfPeople, Income, DeterminationDate, FamilyId, UpdatedAt) VALUES (17739, null, 0, 3, 20000.00, N'2019-08-01', 18267, N'2020-04-22 13:27:07.1686248');
INSERT INTO dbo.FamilyDetermination (Id, AuthorId, NotDisclosed, NumberOfPeople, Income, DeterminationDate, FamilyId, UpdatedAt) VALUES (17740, null, 0, 3, 20000.00, N'2019-08-01', 18268, N'2020-04-22 13:27:07.2289267');
INSERT INTO dbo.FamilyDetermination (Id, AuthorId, NotDisclosed, NumberOfPeople, Income, DeterminationDate, FamilyId, UpdatedAt) VALUES (17741, null, 0, 3, 20000.00, N'2019-08-01', 18269, N'2020-04-22 13:27:07.2891061');
INSERT INTO dbo.FamilyDetermination (Id, AuthorId, NotDisclosed, NumberOfPeople, Income, DeterminationDate, FamilyId, UpdatedAt) VALUES (17742, null, 0, 3, 20000.00, N'2019-08-01', 18270, N'2020-04-22 13:27:07.3526703');
INSERT INTO dbo.FamilyDetermination (Id, AuthorId, NotDisclosed, NumberOfPeople, Income, DeterminationDate, FamilyId, UpdatedAt) VALUES (17743, null, 0, 3, 20000.00, N'2019-08-01', 18271, N'2020-04-22 13:27:07.4157045');
INSERT INTO dbo.FamilyDetermination (Id, AuthorId, NotDisclosed, NumberOfPeople, Income, DeterminationDate, FamilyId, UpdatedAt) VALUES (17744, null, 0, 3, 20000.00, N'2019-08-01', 18272, N'2020-04-22 13:27:07.5004972');
INSERT INTO dbo.FamilyDetermination (Id, AuthorId, NotDisclosed, NumberOfPeople, Income, DeterminationDate, FamilyId, UpdatedAt) VALUES (17745, null, 0, 3, 20000.00, N'2019-08-01', 18273, N'2020-04-22 13:27:07.5971474');
INSERT INTO dbo.FamilyDetermination (Id, AuthorId, NotDisclosed, NumberOfPeople, Income, DeterminationDate, FamilyId, UpdatedAt) VALUES (17746, null, 0, 3, 20000.00, N'2019-08-01', 18274, N'2020-04-22 13:27:07.6683711');
INSERT INTO dbo.FamilyDetermination (Id, AuthorId, NotDisclosed, NumberOfPeople, Income, DeterminationDate, FamilyId, UpdatedAt) VALUES (17747, null, 0, 3, 20000.00, N'2019-08-01', 18275, N'2020-04-22 13:27:07.7648876');
INSERT INTO dbo.FamilyDetermination (Id, AuthorId, NotDisclosed, NumberOfPeople, Income, DeterminationDate, FamilyId, UpdatedAt) VALUES (17748, null, 0, 3, 20000.00, N'2019-08-01', 18276, N'2020-04-22 13:27:07.8324441');
INSERT INTO dbo.FamilyDetermination (Id, AuthorId, NotDisclosed, NumberOfPeople, Income, DeterminationDate, FamilyId, UpdatedAt) VALUES (17749, null, 0, 3, 20000.00, N'2019-08-01', 18277, N'2020-04-22 13:27:07.9013214');