create table Funding
(
    Id                     int identity
        constraint PK_Funding
            primary key,
    AuthorId               int,
    EnrollmentId           int,
    Source                 int,
    FirstReportingPeriodId int,
    LastReportingPeriodId  int,
    SysStartTime           datetime2(0)
        constraint Funding_SysStart default sysutcdatetime()                             not null,
    SysEndTime             datetime2(0)
        constraint Funding_SysEnd default CONVERT([datetime2](0), '9999-12-31 23:59:59') not null,
    UpdatedAt              datetime2,
    FundingSpaceId         int,
    Time int
) WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.FundingHistory))
go

create index IX_Funding_AuthorId
    on Funding (AuthorId)
go

create index IX_Funding_EnrollmentId
    on Funding (EnrollmentId)
go

create index IX_Funding_FirstReportingPeriodId
    on Funding (FirstReportingPeriodId)
go

create index IX_Funding_LastReportingPeriodId
    on Funding (LastReportingPeriodId)
go

create index IX_Funding_FundingSpaceId
    on Funding (FundingSpaceId)
go

SET IDENTITY_INSERT Funding ON
INSERT INTO dbo.Funding (Id, AuthorId, EnrollmentId, Source, FirstReportingPeriodId, LastReportingPeriodId, UpdatedAt, FundingSpaceId, Time) VALUES (18210, null, 21226, 0, 10944, null, N'2020-04-22 13:27:05.4314856', 1164,1);
INSERT INTO dbo.Funding (Id, AuthorId, EnrollmentId, Source, FirstReportingPeriodId, LastReportingPeriodId, UpdatedAt, FundingSpaceId, Time) VALUES (18211, null, 21227, 0, 10944, null, N'2020-04-22 13:27:05.4915721', 1165,1);
INSERT INTO dbo.Funding (Id, AuthorId, EnrollmentId, Source, FirstReportingPeriodId, LastReportingPeriodId, UpdatedAt, FundingSpaceId, Time) VALUES (18212, null, 21229, 0, 10932, null, N'2020-04-22 13:27:05.5907307', 1165,0);
INSERT INTO dbo.Funding (Id, AuthorId, EnrollmentId, Source, FirstReportingPeriodId, LastReportingPeriodId, UpdatedAt, FundingSpaceId, Time) VALUES (18213, null, 21230, 0, 10920, 10931, N'2020-04-22 13:27:05.6078329', 1164,0);
INSERT INTO dbo.Funding (Id, AuthorId, EnrollmentId, Source, FirstReportingPeriodId, LastReportingPeriodId, UpdatedAt, FundingSpaceId, Time) VALUES (18214, null, 21231, 0, 10932, null, N'2020-04-22 13:27:05.6513256', 1165,0);
INSERT INTO dbo.Funding (Id, AuthorId, EnrollmentId, Source, FirstReportingPeriodId, LastReportingPeriodId, UpdatedAt, FundingSpaceId, Time) VALUES (18215, null, 21232, 0, 10920, 10931, N'2020-04-22 13:27:05.6701478', 1164,0);
INSERT INTO dbo.Funding (Id, AuthorId, EnrollmentId, Source, FirstReportingPeriodId, LastReportingPeriodId, UpdatedAt, FundingSpaceId, Time) VALUES (18216, null, 21233, 0, 10944, null, N'2020-04-22 13:27:05.7164703', 1164,0);
INSERT INTO dbo.Funding (Id, AuthorId, EnrollmentId, Source, FirstReportingPeriodId, LastReportingPeriodId, UpdatedAt, FundingSpaceId, Time) VALUES (18217, null, 21234, 0, 10932, null, N'2020-04-22 13:27:05.7650727', 1165,0);
INSERT INTO dbo.Funding (Id, AuthorId, EnrollmentId, Source, FirstReportingPeriodId, LastReportingPeriodId, UpdatedAt, FundingSpaceId, Time) VALUES (18218, null, 21235, 0, 10920, 10931, N'2020-04-22 13:27:05.7840984', 1164,0);
INSERT INTO dbo.Funding (Id, AuthorId, EnrollmentId, Source, FirstReportingPeriodId, LastReportingPeriodId, UpdatedAt, FundingSpaceId, Time) VALUES (18219, null, 21236, 0, 10944, null, N'2020-04-22 13:27:05.8344041', 1164,0);
INSERT INTO dbo.Funding (Id, AuthorId, EnrollmentId, Source, FirstReportingPeriodId, LastReportingPeriodId, UpdatedAt, FundingSpaceId, Time) VALUES (18220, null, 21237, 0, 10944, null, N'2020-04-22 13:27:05.8854960', 1165,0);
INSERT INTO dbo.Funding (Id, AuthorId, EnrollmentId, Source, FirstReportingPeriodId, LastReportingPeriodId, UpdatedAt, FundingSpaceId, Time) VALUES (18221, 883, 21238, 0, 10944, null, N'2020-04-22 15:40:27.9939138', null, null);
INSERT INTO dbo.Funding (Id, AuthorId, EnrollmentId, Source, FirstReportingPeriodId, LastReportingPeriodId, UpdatedAt, FundingSpaceId, Time) VALUES (18222, null, 21239, 0, 10932, 10943, N'2020-04-22 13:27:05.9935581', 1165,0);
INSERT INTO dbo.Funding (Id, AuthorId, EnrollmentId, Source, FirstReportingPeriodId, LastReportingPeriodId, UpdatedAt, FundingSpaceId, Time) VALUES (18223, null, 21240, 0, 10920, 10931, N'2020-04-22 13:27:06.0279994', 1164,0);
INSERT INTO dbo.Funding (Id, AuthorId, EnrollmentId, Source, FirstReportingPeriodId, LastReportingPeriodId, UpdatedAt, FundingSpaceId, Time) VALUES (18224, null, 21242, 0, 10944, null, N'2020-04-22 13:27:06.1364719', 1164,0);
INSERT INTO dbo.Funding (Id, AuthorId, EnrollmentId, Source, FirstReportingPeriodId, LastReportingPeriodId, UpdatedAt, FundingSpaceId, Time) VALUES (18225, null, 21243, 0, 10948, 10949, N'2020-04-22 13:27:06.1954972', 1164,1);
INSERT INTO dbo.Funding (Id, AuthorId, EnrollmentId, Source, FirstReportingPeriodId, LastReportingPeriodId, UpdatedAt, FundingSpaceId, Time) VALUES (18226, null, 21243, 0, 10950, null, N'2020-04-22 13:27:06.2072331', 1164,0);
INSERT INTO dbo.Funding (Id, AuthorId, EnrollmentId, Source, FirstReportingPeriodId, LastReportingPeriodId, UpdatedAt, FundingSpaceId, Time) VALUES (18227, null, 21244, 0, 10944, null, N'2020-04-22 13:27:06.2657488', 1164,0);
INSERT INTO dbo.Funding (Id, AuthorId, EnrollmentId, Source, FirstReportingPeriodId, LastReportingPeriodId, UpdatedAt, FundingSpaceId, Time) VALUES (18228, null, 21246, 0, 10944, null, N'2020-04-22 13:27:06.3599907', 1165,1);
INSERT INTO dbo.Funding (Id, AuthorId, EnrollmentId, Source, FirstReportingPeriodId, LastReportingPeriodId, UpdatedAt, FundingSpaceId, Time) VALUES (18229, null, 21247, 0, 10944, null, N'2020-04-22 13:27:06.4133788', 1165,0);
INSERT INTO dbo.Funding (Id, AuthorId, EnrollmentId, Source, FirstReportingPeriodId, LastReportingPeriodId, UpdatedAt, FundingSpaceId, Time) VALUES (18230, null, 21250, 0, 10932, 10943, N'2020-04-22 13:27:06.5216517', 1165,0);
INSERT INTO dbo.Funding (Id, AuthorId, EnrollmentId, Source, FirstReportingPeriodId, LastReportingPeriodId, UpdatedAt, FundingSpaceId, Time) VALUES (18231, null, 21251, 0, 10920, 10931, N'2020-04-22 13:27:06.5420992', 1164,0);
INSERT INTO dbo.Funding (Id, AuthorId, EnrollmentId, Source, FirstReportingPeriodId, LastReportingPeriodId, UpdatedAt, FundingSpaceId, Time) VALUES (18232, null, 21252, 0, 10944, null, N'2020-04-22 13:27:06.5938055', 1165,1);
INSERT INTO dbo.Funding (Id, AuthorId, EnrollmentId, Source, FirstReportingPeriodId, LastReportingPeriodId, UpdatedAt, FundingSpaceId, Time) VALUES (18233, 883, 21255, 0, 10944, null, N'2020-04-22 15:08:34.1627809', 1164,0);
INSERT INTO dbo.Funding (Id, AuthorId, EnrollmentId, Source, FirstReportingPeriodId, LastReportingPeriodId, UpdatedAt, FundingSpaceId, Time) VALUES (18234, null, 21257, 0, 10944, null, N'2020-04-22 13:27:06.8227531', 1165,0);
INSERT INTO dbo.Funding (Id, AuthorId, EnrollmentId, Source, FirstReportingPeriodId, LastReportingPeriodId, UpdatedAt, FundingSpaceId, Time) VALUES (18235, null, 21258, 0, 10932, 10943, N'2020-04-22 13:27:06.8971158', 1165,0);
INSERT INTO dbo.Funding (Id, AuthorId, EnrollmentId, Source, FirstReportingPeriodId, LastReportingPeriodId, UpdatedAt, FundingSpaceId, Time) VALUES (18236, null, 21259, 0, 10920, 10931, N'2020-04-22 13:27:06.9215394', 1164,0);
INSERT INTO dbo.Funding (Id, AuthorId, EnrollmentId, Source, FirstReportingPeriodId, LastReportingPeriodId, UpdatedAt, FundingSpaceId, Time) VALUES (18237, null, 21260, 0, 10944, null, N'2020-04-22 13:27:06.9843011', 1165,0);
INSERT INTO dbo.Funding (Id, AuthorId, EnrollmentId, Source, FirstReportingPeriodId, LastReportingPeriodId, UpdatedAt, FundingSpaceId, Time) VALUES (18238, null, 21261, 0, 10944, null, N'2020-04-22 13:27:07.0547706', 1165,0);
INSERT INTO dbo.Funding (Id, AuthorId, EnrollmentId, Source, FirstReportingPeriodId, LastReportingPeriodId, UpdatedAt, FundingSpaceId, Time) VALUES (18239, null, 21262, 0, 10944, null, N'2020-04-22 13:27:07.1313482', 1165,0);
INSERT INTO dbo.Funding (Id, AuthorId, EnrollmentId, Source, FirstReportingPeriodId, LastReportingPeriodId, UpdatedAt, FundingSpaceId, Time) VALUES (18240, null, 21263, 0, 10944, null, N'2020-04-22 13:27:07.2046839', 1164,1);
INSERT INTO dbo.Funding (Id, AuthorId, EnrollmentId, Source, FirstReportingPeriodId, LastReportingPeriodId, UpdatedAt, FundingSpaceId, Time) VALUES (18241, null, 21264, 0, 10944, null, N'2020-04-22 13:27:07.2650685', 1165,1);
INSERT INTO dbo.Funding (Id, AuthorId, EnrollmentId, Source, FirstReportingPeriodId, LastReportingPeriodId, UpdatedAt, FundingSpaceId, Time) VALUES (18242, null, 21265, 0, 10944, null, N'2020-04-22 13:27:07.3277942', 1165,0);
INSERT INTO dbo.Funding (Id, AuthorId, EnrollmentId, Source, FirstReportingPeriodId, LastReportingPeriodId, UpdatedAt, FundingSpaceId, Time) VALUES (18243, null, 21266, 0, 10944, null, N'2020-04-22 13:27:07.3903225', 1165,1);
INSERT INTO dbo.Funding (Id, AuthorId, EnrollmentId, Source, FirstReportingPeriodId, LastReportingPeriodId, UpdatedAt, FundingSpaceId, Time) VALUES (18244, null, 21269, 0, 10932, null, N'2020-04-22 13:27:07.5425507', 1165,0);
INSERT INTO dbo.Funding (Id, AuthorId, EnrollmentId, Source, FirstReportingPeriodId, LastReportingPeriodId, UpdatedAt, FundingSpaceId, Time) VALUES (18245, null, 21270, 0, 10920, 10931, N'2020-04-22 13:27:07.5701351', 1164,0);
INSERT INTO dbo.Funding (Id, AuthorId, EnrollmentId, Source, FirstReportingPeriodId, LastReportingPeriodId, UpdatedAt, FundingSpaceId, Time) VALUES (18246, null, 21271, 0, 10944, null, N'2020-04-22 13:27:07.6382092', 1165,0);
INSERT INTO dbo.Funding (Id, AuthorId, EnrollmentId, Source, FirstReportingPeriodId, LastReportingPeriodId, UpdatedAt, FundingSpaceId, Time) VALUES (18247, null, 21272, 0, 10932, 10943, N'2020-04-22 13:27:07.7101184', 1165,0);
INSERT INTO dbo.Funding (Id, AuthorId, EnrollmentId, Source, FirstReportingPeriodId, LastReportingPeriodId, UpdatedAt, FundingSpaceId, Time) VALUES (18248, null, 21273, 0, 10920, 10931, N'2020-04-22 13:27:07.7380418', 1164,0);
INSERT INTO dbo.Funding (Id, AuthorId, EnrollmentId, Source, FirstReportingPeriodId, LastReportingPeriodId, UpdatedAt, FundingSpaceId, Time) VALUES (18249, null, 21274, 0, 10944, null, N'2020-04-22 13:27:07.8053470', 1164,1);
INSERT INTO dbo.Funding (Id, AuthorId, EnrollmentId, Source, FirstReportingPeriodId, LastReportingPeriodId, UpdatedAt, FundingSpaceId, Time) VALUES (18250, null, 21275, 0, 10944, null, N'2020-04-22 13:27:07.8740219', 1165,1);
INSERT INTO dbo.Funding (Id, AuthorId, EnrollmentId, Source, FirstReportingPeriodId, LastReportingPeriodId, UpdatedAt, FundingSpaceId, Time) VALUES (18251, null, 21276, 0, 10944, null, N'2020-04-22 13:27:07.9428594', 1165,1);