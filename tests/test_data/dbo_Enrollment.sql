create table Enrollment
(
    Id           int identity
        constraint PK_Enrollment
            primary key,
    AuthorId     int,
    ChildId      uniqueidentifier,
    SiteId       int,
    AgeGroup     int,
    Entry        date,
    [Exit]       date,
    ExitReason   nvarchar(max),
    SysStartTime datetime2(0)
        constraint Enrollment_SysStart default sysutcdatetime()                             not null,
    SysEndTime   datetime2(0)
        constraint Enrollment_SysEnd default CONVERT([datetime2](0), '9999-12-31 23:59:59') not null,
    UpdatedAt    datetime2
) WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.EnrollmentHistory))
go
SET IDENTITY_INSERT Enrollment ON
create index IX_Enrollment_AuthorId
    on Enrollment (AuthorId)
go

create index IX_Enrollment_ChildId
    on Enrollment (ChildId)
go

create index IX_Enrollment_SiteId
    on Enrollment (SiteId)
go

INSERT INTO dbo.Enrollment (Id, AuthorId, ChildId, SiteId, AgeGroup, Entry, [Exit], ExitReason, UpdatedAt) VALUES (21226, 883, N'782D2A7C-CB2E-4404-4B75-08D7E6C0D989', 1073, 0, N'2019-09-02', null, null, N'2020-04-22 13:27:05.4148101');
INSERT INTO dbo.Enrollment (Id, AuthorId, ChildId, SiteId, AgeGroup, Entry, [Exit], ExitReason, UpdatedAt) VALUES (21227, 883, N'FEF5C86E-68B0-49F7-4B76-08D7E6C0D989', 1072, 1, N'2019-09-02', null, null, N'2020-04-22 13:27:05.4831202');
INSERT INTO dbo.Enrollment (Id, AuthorId, ChildId, SiteId, AgeGroup, Entry, [Exit], ExitReason, UpdatedAt) VALUES (21228, 883, N'E2C6119F-04AB-4219-4B77-08D7E6C0D989', 1072, 1, N'2019-09-02', null, null, N'2020-04-22 13:27:05.5259535');
INSERT INTO dbo.Enrollment (Id, AuthorId, ChildId, SiteId, AgeGroup, Entry, [Exit], ExitReason, UpdatedAt) VALUES (21229, 883, N'8602E764-4AB2-497C-4B78-08D7E6C0D989', 1072, 1, N'2018-09-03', null, null, N'2020-04-22 13:27:05.5824629');
INSERT INTO dbo.Enrollment (Id, AuthorId, ChildId, SiteId, AgeGroup, Entry, [Exit], ExitReason, UpdatedAt) VALUES (21230, null, N'8602E764-4AB2-497C-4B78-08D7E6C0D989', 1072, 0, N'2017-09-04', N'2018-09-03', N'Other', N'2020-04-22 13:27:05.5994057');
INSERT INTO dbo.Enrollment (Id, AuthorId, ChildId, SiteId, AgeGroup, Entry, [Exit], ExitReason, UpdatedAt) VALUES (21231, 883, N'CD74072B-1892-411A-4B79-08D7E6C0D989', 1072, 1, N'2018-09-03', null, null, N'2020-04-22 13:27:05.6423540');
INSERT INTO dbo.Enrollment (Id, AuthorId, ChildId, SiteId, AgeGroup, Entry, [Exit], ExitReason, UpdatedAt) VALUES (21232, null, N'CD74072B-1892-411A-4B79-08D7E6C0D989', 1072, 0, N'2017-09-04', N'2018-09-03', N'Other', N'2020-04-22 13:27:05.6602321');
INSERT INTO dbo.Enrollment (Id, AuthorId, ChildId, SiteId, AgeGroup, Entry, [Exit], ExitReason, UpdatedAt) VALUES (21233, 883, N'93554837-68D7-4834-4B7A-08D7E6C0D989', 1072, 0, N'2019-09-02', null, null, N'2020-04-22 13:27:05.7071592');
INSERT INTO dbo.Enrollment (Id, AuthorId, ChildId, SiteId, AgeGroup, Entry, [Exit], ExitReason, UpdatedAt) VALUES (21234, 883, N'5E157AD4-A6F6-48F1-4B7B-08D7E6C0D989', 1072, 1, N'2018-09-03', null, null, N'2020-04-22 13:27:05.7553464');
INSERT INTO dbo.Enrollment (Id, AuthorId, ChildId, SiteId, AgeGroup, Entry, [Exit], ExitReason, UpdatedAt) VALUES (21235, null, N'5E157AD4-A6F6-48F1-4B7B-08D7E6C0D989', 1072, 0, N'2017-09-04', N'2018-09-03', N'Other', N'2020-04-22 13:27:05.7745298');
INSERT INTO dbo.Enrollment (Id, AuthorId, ChildId, SiteId, AgeGroup, Entry, [Exit], ExitReason, UpdatedAt) VALUES (21236, 883, N'3050BFED-B620-41AD-4B7C-08D7E6C0D989', 1072, 0, N'2019-09-02', null, null, N'2020-04-22 13:27:05.8238463');
INSERT INTO dbo.Enrollment (Id, AuthorId, ChildId, SiteId, AgeGroup, Entry, [Exit], ExitReason, UpdatedAt) VALUES (21237, 883, N'8B8ED2ED-C262-446D-4B7D-08D7E6C0D989', 1072, 1, N'2019-09-02', null, null, N'2020-04-22 13:27:05.8751878');
INSERT INTO dbo.Enrollment (Id, AuthorId, ChildId, SiteId, AgeGroup, Entry, [Exit], ExitReason, UpdatedAt) VALUES (21238, 883, N'01BEC04E-4BF2-4766-4B7E-08D7E6C0D989', 1072, 0, N'2019-09-02', null, null, N'2020-04-22 15:40:27.9939138');
INSERT INTO dbo.Enrollment (Id, AuthorId, ChildId, SiteId, AgeGroup, Entry, [Exit], ExitReason, UpdatedAt) VALUES (21239, 883, N'6BC71B17-06D6-49BC-4B7F-08D7E6C0D989', 1072, 1, N'2018-09-03', N'2019-08-30', N'Other', N'2020-04-22 13:27:05.9827132');
INSERT INTO dbo.Enrollment (Id, AuthorId, ChildId, SiteId, AgeGroup, Entry, [Exit], ExitReason, UpdatedAt) VALUES (21240, null, N'6BC71B17-06D6-49BC-4B7F-08D7E6C0D989', 1072, 0, N'2017-09-04', N'2018-09-03', N'Other', N'2020-04-22 13:27:06.0171273');
INSERT INTO dbo.Enrollment (Id, AuthorId, ChildId, SiteId, AgeGroup, Entry, [Exit], ExitReason, UpdatedAt) VALUES (21241, 883, N'00906EDC-BDD5-4EFF-4B80-08D7E6C0D989', 1072, 1, N'2019-09-02', null, null, N'2020-04-22 13:27:06.0744246');
INSERT INTO dbo.Enrollment (Id, AuthorId, ChildId, SiteId, AgeGroup, Entry, [Exit], ExitReason, UpdatedAt) VALUES (21242, 883, N'87C9D199-60B6-4B62-4B81-08D7E6C0D989', 1072, 0, N'2019-09-02', null, null, N'2020-04-22 13:27:06.1250566');
INSERT INTO dbo.Enrollment (Id, AuthorId, ChildId, SiteId, AgeGroup, Entry, [Exit], ExitReason, UpdatedAt) VALUES (21243, 883, N'50A96665-92A3-408E-4B82-08D7E6C0D989', 1072, 0, N'2019-09-02', null, null, N'2020-04-22 13:27:06.1834698');
INSERT INTO dbo.Enrollment (Id, AuthorId, ChildId, SiteId, AgeGroup, Entry, [Exit], ExitReason, UpdatedAt) VALUES (21244, 883, N'6B293F4C-128C-4F8A-4B83-08D7E6C0D989', 1072, 0, N'2019-09-02', null, null, N'2020-04-22 13:27:06.2554692');
INSERT INTO dbo.Enrollment (Id, AuthorId, ChildId, SiteId, AgeGroup, Entry, [Exit], ExitReason, UpdatedAt) VALUES (21245, 883, N'6D4EC864-A4CD-4FEA-4B84-08D7E6C0D989', 1072, 0, N'2019-09-02', null, null, N'2020-04-22 13:27:06.3069874');
INSERT INTO dbo.Enrollment (Id, AuthorId, ChildId, SiteId, AgeGroup, Entry, [Exit], ExitReason, UpdatedAt) VALUES (21246, 883, N'63EF8305-40CC-436A-4B85-08D7E6C0D989', 1072, 1, N'2019-09-02', null, null, N'2020-04-22 13:27:06.3493106');
INSERT INTO dbo.Enrollment (Id, AuthorId, ChildId, SiteId, AgeGroup, Entry, [Exit], ExitReason, UpdatedAt) VALUES (21247, 883, N'F933B238-A9B4-49E6-4B86-08D7E6C0D989', 1072, 1, N'2019-09-02', null, null, N'2020-04-22 13:27:06.4027745');
INSERT INTO dbo.Enrollment (Id, AuthorId, ChildId, SiteId, AgeGroup, Entry, [Exit], ExitReason, UpdatedAt) VALUES (21248, 883, N'A8699690-799F-45BE-4B87-08D7E6C0D989', 1072, 1, N'2018-09-03', null, null, N'2020-04-22 13:27:06.4565223');
INSERT INTO dbo.Enrollment (Id, AuthorId, ChildId, SiteId, AgeGroup, Entry, [Exit], ExitReason, UpdatedAt) VALUES (21249, null, N'A8699690-799F-45BE-4B87-08D7E6C0D989', 1072, 0, N'2017-09-04', N'2018-09-03', N'Other', N'2020-04-22 13:27:06.4694270');
INSERT INTO dbo.Enrollment (Id, AuthorId, ChildId, SiteId, AgeGroup, Entry, [Exit], ExitReason, UpdatedAt) VALUES (21250, 883, N'E305D7FB-EF87-4A85-4B88-08D7E6C0D989', 1072, 1, N'2018-09-03', N'2019-08-30', N'Other', N'2020-04-22 13:27:06.5114796');
INSERT INTO dbo.Enrollment (Id, AuthorId, ChildId, SiteId, AgeGroup, Entry, [Exit], ExitReason, UpdatedAt) VALUES (21251, null, N'E305D7FB-EF87-4A85-4B88-08D7E6C0D989', 1072, 0, N'2017-09-04', N'2018-09-03', N'Other', N'2020-04-22 13:27:06.5318599');
INSERT INTO dbo.Enrollment (Id, AuthorId, ChildId, SiteId, AgeGroup, Entry, [Exit], ExitReason, UpdatedAt) VALUES (21252, 883, N'811E9F83-554D-4456-4B89-08D7E6C0D989', 1072, 1, N'2019-09-02', null, null, N'2020-04-22 13:27:06.5834792');
INSERT INTO dbo.Enrollment (Id, AuthorId, ChildId, SiteId, AgeGroup, Entry, [Exit], ExitReason, UpdatedAt) VALUES (21253, 883, N'56F579F9-77D1-4908-4B8A-08D7E6C0D989', 1072, 1, N'2018-09-03', null, null, N'2020-04-22 13:27:06.6354886');
INSERT INTO dbo.Enrollment (Id, AuthorId, ChildId, SiteId, AgeGroup, Entry, [Exit], ExitReason, UpdatedAt) VALUES (21254, null, N'56F579F9-77D1-4908-4B8A-08D7E6C0D989', 1072, 0, N'2017-09-04', N'2018-09-03', N'Other', N'2020-04-22 13:27:06.6464732');
INSERT INTO dbo.Enrollment (Id, AuthorId, ChildId, SiteId, AgeGroup, Entry, [Exit], ExitReason, UpdatedAt) VALUES (21255, 883, N'88D9E142-8205-4C59-4B8B-08D7E6C0D989', 1072, 0, N'2019-09-02', null, null, N'2020-04-22 15:08:34.1627809');
INSERT INTO dbo.Enrollment (Id, AuthorId, ChildId, SiteId, AgeGroup, Entry, [Exit], ExitReason, UpdatedAt) VALUES (21256, 883, N'AD8D2381-B08F-4125-4B8C-08D7E6C0D989', 1072, 1, N'2019-09-02', null, null, N'2020-04-22 13:27:06.7496854');
INSERT INTO dbo.Enrollment (Id, AuthorId, ChildId, SiteId, AgeGroup, Entry, [Exit], ExitReason, UpdatedAt) VALUES (21257, 883, N'D8B828AE-555A-4E9A-4B8D-08D7E6C0D989', 1072, 1, N'2019-09-02', null, null, N'2020-04-22 13:27:06.8107858');
INSERT INTO dbo.Enrollment (Id, AuthorId, ChildId, SiteId, AgeGroup, Entry, [Exit], ExitReason, UpdatedAt) VALUES (21258, 883, N'03E92AE3-B439-4A2E-4B8E-08D7E6C0D989', 1072, 1, N'2018-09-03', N'2019-08-30', N'Other', N'2020-04-22 13:27:06.8848000');
INSERT INTO dbo.Enrollment (Id, AuthorId, ChildId, SiteId, AgeGroup, Entry, [Exit], ExitReason, UpdatedAt) VALUES (21259, null, N'03E92AE3-B439-4A2E-4B8E-08D7E6C0D989', 1072, 0, N'2017-09-04', N'2018-09-03', N'Other', N'2020-04-22 13:27:06.9092440');
INSERT INTO dbo.Enrollment (Id, AuthorId, ChildId, SiteId, AgeGroup, Entry, [Exit], ExitReason, UpdatedAt) VALUES (21260, 883, N'13B8A631-DA91-409D-4B8F-08D7E6C0D989', 1072, 1, N'2019-09-02', null, null, N'2020-04-22 13:27:06.9715024');
INSERT INTO dbo.Enrollment (Id, AuthorId, ChildId, SiteId, AgeGroup, Entry, [Exit], ExitReason, UpdatedAt) VALUES (21261, 883, N'A111A24A-0E8F-4DD7-4B90-08D7E6C0D989', 1072, 1, N'2019-09-02', null, null, N'2020-04-22 13:27:07.0419791');
INSERT INTO dbo.Enrollment (Id, AuthorId, ChildId, SiteId, AgeGroup, Entry, [Exit], ExitReason, UpdatedAt) VALUES (21262, 883, N'97BA050A-7406-4851-4B91-08D7E6C0D989', 1072, 1, N'2019-09-02', null, null, N'2020-04-22 13:27:07.1044334');
INSERT INTO dbo.Enrollment (Id, AuthorId, ChildId, SiteId, AgeGroup, Entry, [Exit], ExitReason, UpdatedAt) VALUES (21263, 883, N'E3CE41FF-2A98-4753-4B92-08D7E6C0D989', 1072, 0, N'2019-09-02', null, null, N'2020-04-22 13:27:07.1924158');
INSERT INTO dbo.Enrollment (Id, AuthorId, ChildId, SiteId, AgeGroup, Entry, [Exit], ExitReason, UpdatedAt) VALUES (21264, 883, N'AD97C0A3-2FF2-47BE-4B93-08D7E6C0D989', 1072, 1, N'2019-09-02', null, null, N'2020-04-22 13:27:07.2530175');
INSERT INTO dbo.Enrollment (Id, AuthorId, ChildId, SiteId, AgeGroup, Entry, [Exit], ExitReason, UpdatedAt) VALUES (21265, 883, N'8C540539-130F-4E4C-4B94-08D7E6C0D989', 1072, 1, N'2019-09-02', null, null, N'2020-04-22 13:27:07.3150926');
INSERT INTO dbo.Enrollment (Id, AuthorId, ChildId, SiteId, AgeGroup, Entry, [Exit], ExitReason, UpdatedAt) VALUES (21266, 883, N'CA623E8F-DFAA-4346-4B95-08D7E6C0D989', 1072, 1, N'2019-09-02', null, null, N'2020-04-22 13:27:07.3778011');
INSERT INTO dbo.Enrollment (Id, AuthorId, ChildId, SiteId, AgeGroup, Entry, [Exit], ExitReason, UpdatedAt) VALUES (21267, 883, N'6F79CC5E-30EB-4DEA-4B96-08D7E6C0D989', 1072, 1, N'2018-09-03', null, null, N'2020-04-22 13:27:07.4410055');
INSERT INTO dbo.Enrollment (Id, AuthorId, ChildId, SiteId, AgeGroup, Entry, [Exit], ExitReason, UpdatedAt) VALUES (21268, null, N'6F79CC5E-30EB-4DEA-4B96-08D7E6C0D989', 1072, 0, N'2017-09-04', N'2018-09-03', N'Other', N'2020-04-22 13:27:07.4710915');
INSERT INTO dbo.Enrollment (Id, AuthorId, ChildId, SiteId, AgeGroup, Entry, [Exit], ExitReason, UpdatedAt) VALUES (21269, 883, N'FD767A09-95E8-4BA6-4B97-08D7E6C0D989', 1072, 1, N'2018-09-03', null, null, N'2020-04-22 13:27:07.5285354');
INSERT INTO dbo.Enrollment (Id, AuthorId, ChildId, SiteId, AgeGroup, Entry, [Exit], ExitReason, UpdatedAt) VALUES (21270, null, N'FD767A09-95E8-4BA6-4B97-08D7E6C0D989', 1072, 0, N'2017-09-04', N'2018-09-03', N'Other', N'2020-04-22 13:27:07.5564065');
INSERT INTO dbo.Enrollment (Id, AuthorId, ChildId, SiteId, AgeGroup, Entry, [Exit], ExitReason, UpdatedAt) VALUES (21271, 883, N'1192D7AF-C5F7-4605-4B98-08D7E6C0D989', 1072, 1, N'2019-09-02', null, null, N'2020-04-22 13:27:07.6245190');
INSERT INTO dbo.Enrollment (Id, AuthorId, ChildId, SiteId, AgeGroup, Entry, [Exit], ExitReason, UpdatedAt) VALUES (21272, 883, N'336BFA22-20CA-40FB-4B99-08D7E6C0D989', 1072, 1, N'2018-09-03', N'2019-08-30', N'Other', N'2020-04-22 13:27:07.6959961');
INSERT INTO dbo.Enrollment (Id, AuthorId, ChildId, SiteId, AgeGroup, Entry, [Exit], ExitReason, UpdatedAt) VALUES (21273, null, N'336BFA22-20CA-40FB-4B99-08D7E6C0D989', 1072, 0, N'2017-09-04', N'2018-09-03', N'Other', N'2020-04-22 13:27:07.7239882');
INSERT INTO dbo.Enrollment (Id, AuthorId, ChildId, SiteId, AgeGroup, Entry, [Exit], ExitReason, UpdatedAt) VALUES (21274, 883, N'668FF25E-2064-4478-4B9A-08D7E6C0D989', 1072, 0, N'2019-09-02', null, null, N'2020-04-22 13:27:07.7919375');
INSERT INTO dbo.Enrollment (Id, AuthorId, ChildId, SiteId, AgeGroup, Entry, [Exit], ExitReason, UpdatedAt) VALUES (21275, 883, N'4D19A8EA-5528-4167-4B9B-08D7E6C0D989', 1072, 1, N'2019-09-02', null, null, N'2020-04-22 13:27:07.8595055');
INSERT INTO dbo.Enrollment (Id, AuthorId, ChildId, SiteId, AgeGroup, Entry, [Exit], ExitReason, UpdatedAt) VALUES (21276, 883, N'9F82EB6A-75A4-4F6A-4B9C-08D7E6C0D989', 1072, 1, N'2019-09-02', null, null, N'2020-04-22 13:27:07.9288677');
INSERT INTO dbo.Enrollment (Id, AuthorId, ChildId, SiteId, AgeGroup, Entry, [Exit], ExitReason, UpdatedAt) VALUES (21277, null, N'1F05DA01-1796-4F84-4B9D-08D7E6C0D989', 1074, 1, N'2019-08-01', null, null, N'2020-04-22 13:27:08.0138037');