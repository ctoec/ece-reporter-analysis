create table ReportingPeriod
(
    Id          int identity
        constraint PK_ReportingPeriod
            primary key,
    Type        int  not null,
    Period date not null,
    PeriodStart date not null,
    PeriodEnd   date not null,
    DueAt       date not null
)
go

SET IDENTITY_INSERT ReportingPeriod ON
INSERT INTO dbo.ReportingPeriod (Id, Type, Period, PeriodStart, PeriodEnd, DueAt) VALUES (10918, 0, N'2017-07-01', N'2017-07-03', N'2017-07-30', N'2017-08-18');
INSERT INTO dbo.ReportingPeriod (Id, Type, Period, PeriodStart, PeriodEnd, DueAt) VALUES (10919, 0, N'2017-08-01', N'2017-07-31', N'2017-08-27', N'2017-09-15');
INSERT INTO dbo.ReportingPeriod (Id, Type, Period, PeriodStart, PeriodEnd, DueAt) VALUES (10920, 0, N'2017-09-01', N'2017-08-28', N'2017-10-01', N'2017-10-20');
INSERT INTO dbo.ReportingPeriod (Id, Type, Period, PeriodStart, PeriodEnd, DueAt) VALUES (10921, 0, N'2017-10-01', N'2017-10-02', N'2017-10-29', N'2017-11-17');
INSERT INTO dbo.ReportingPeriod (Id, Type, Period, PeriodStart, PeriodEnd, DueAt) VALUES (10922, 0, N'2017-11-01', N'2017-10-30', N'2017-11-26', N'2017-12-15');
INSERT INTO dbo.ReportingPeriod (Id, Type, Period, PeriodStart, PeriodEnd, DueAt) VALUES (10923, 0, N'2017-12-01', N'2017-11-27', N'2017-12-31', N'2018-01-19');
INSERT INTO dbo.ReportingPeriod (Id, Type, Period, PeriodStart, PeriodEnd, DueAt) VALUES (10924, 0, N'2018-01-01', N'2018-01-01', N'2018-01-28', N'2018-02-16');
INSERT INTO dbo.ReportingPeriod (Id, Type, Period, PeriodStart, PeriodEnd, DueAt) VALUES (10925, 0, N'2018-02-01', N'2018-01-29', N'2018-02-25', N'2018-03-16');
INSERT INTO dbo.ReportingPeriod (Id, Type, Period, PeriodStart, PeriodEnd, DueAt) VALUES (10926, 0, N'2018-03-01', N'2018-02-26', N'2018-04-01', N'2018-04-20');
INSERT INTO dbo.ReportingPeriod (Id, Type, Period, PeriodStart, PeriodEnd, DueAt) VALUES (10927, 0, N'2018-04-01', N'2018-04-02', N'2018-04-29', N'2018-05-18');
INSERT INTO dbo.ReportingPeriod (Id, Type, Period, PeriodStart, PeriodEnd, DueAt) VALUES (10928, 0, N'2018-05-01', N'2018-04-30', N'2018-05-27', N'2018-06-15');
INSERT INTO dbo.ReportingPeriod (Id, Type, Period, PeriodStart, PeriodEnd, DueAt) VALUES (10929, 0, N'2018-06-01', N'2018-05-28', N'2018-07-01', N'2018-07-20');
INSERT INTO dbo.ReportingPeriod (Id, Type, Period, PeriodStart, PeriodEnd, DueAt) VALUES (10930, 0, N'2018-07-01', N'2018-07-02', N'2018-07-29', N'2018-08-17');
INSERT INTO dbo.ReportingPeriod (Id, Type, Period, PeriodStart, PeriodEnd, DueAt) VALUES (10931, 0, N'2018-08-01', N'2018-07-30', N'2018-09-02', N'2018-09-21');
INSERT INTO dbo.ReportingPeriod (Id, Type, Period, PeriodStart, PeriodEnd, DueAt) VALUES (10932, 0, N'2018-09-01', N'2018-09-03', N'2018-09-30', N'2018-10-19');
INSERT INTO dbo.ReportingPeriod (Id, Type, Period, PeriodStart, PeriodEnd, DueAt) VALUES (10933, 0, N'2018-10-01', N'2018-10-01', N'2018-10-28', N'2018-11-16');
INSERT INTO dbo.ReportingPeriod (Id, Type, Period, PeriodStart, PeriodEnd, DueAt) VALUES (10934, 0, N'2018-11-01', N'2018-10-29', N'2018-12-02', N'2018-12-21');
INSERT INTO dbo.ReportingPeriod (Id, Type, Period, PeriodStart, PeriodEnd, DueAt) VALUES (10935, 0, N'2018-12-01', N'2018-12-03', N'2018-12-30', N'2019-01-18');
INSERT INTO dbo.ReportingPeriod (Id, Type, Period, PeriodStart, PeriodEnd, DueAt) VALUES (10936, 0, N'2019-01-01', N'2018-12-31', N'2019-01-27', N'2019-02-15');
INSERT INTO dbo.ReportingPeriod (Id, Type, Period, PeriodStart, PeriodEnd, DueAt) VALUES (10937, 0, N'2019-02-01', N'2019-01-28', N'2019-02-24', N'2019-03-15');
INSERT INTO dbo.ReportingPeriod (Id, Type, Period, PeriodStart, PeriodEnd, DueAt) VALUES (10938, 0, N'2019-03-01', N'2019-02-25', N'2019-03-31', N'2019-04-19');
INSERT INTO dbo.ReportingPeriod (Id, Type, Period, PeriodStart, PeriodEnd, DueAt) VALUES (10939, 0, N'2019-04-01', N'2019-04-01', N'2019-04-28', N'2019-05-17');
INSERT INTO dbo.ReportingPeriod (Id, Type, Period, PeriodStart, PeriodEnd, DueAt) VALUES (10940, 0, N'2019-05-01', N'2019-04-29', N'2019-06-02', N'2019-06-21');
INSERT INTO dbo.ReportingPeriod (Id, Type, Period, PeriodStart, PeriodEnd, DueAt) VALUES (10941, 0, N'2019-06-01', N'2019-06-03', N'2019-06-30', N'2019-07-19');
INSERT INTO dbo.ReportingPeriod (Id, Type, Period, PeriodStart, PeriodEnd, DueAt) VALUES (10942, 0, N'2019-07-01', N'2019-07-01', N'2019-07-28', N'2019-08-16');
INSERT INTO dbo.ReportingPeriod (Id, Type, Period, PeriodStart, PeriodEnd, DueAt) VALUES (10943, 0, N'2019-08-01', N'2019-07-29', N'2019-09-01', N'2019-09-20');
INSERT INTO dbo.ReportingPeriod (Id, Type, Period, PeriodStart, PeriodEnd, DueAt) VALUES (10944, 0, N'2019-09-01', N'2019-09-02', N'2019-09-29', N'2019-10-18');
INSERT INTO dbo.ReportingPeriod (Id, Type, Period, PeriodStart, PeriodEnd, DueAt) VALUES (10945, 0, N'2019-10-01', N'2019-09-30', N'2019-10-27', N'2019-11-15');
INSERT INTO dbo.ReportingPeriod (Id, Type, Period, PeriodStart, PeriodEnd, DueAt) VALUES (10946, 0, N'2019-11-01', N'2019-10-28', N'2019-12-01', N'2019-12-20');
INSERT INTO dbo.ReportingPeriod (Id, Type, Period, PeriodStart, PeriodEnd, DueAt) VALUES (10947, 0, N'2019-12-01', N'2019-12-02', N'2019-12-29', N'2020-01-17');
INSERT INTO dbo.ReportingPeriod (Id, Type, Period, PeriodStart, PeriodEnd, DueAt) VALUES (10948, 0, N'2020-01-01', N'2019-12-30', N'2020-02-02', N'2020-02-21');
INSERT INTO dbo.ReportingPeriod (Id, Type, Period, PeriodStart, PeriodEnd, DueAt) VALUES (10949, 0, N'2020-02-01', N'2020-02-03', N'2020-03-01', N'2020-03-20');
INSERT INTO dbo.ReportingPeriod (Id, Type, Period, PeriodStart, PeriodEnd, DueAt) VALUES (10950, 0, N'2020-03-01', N'2020-03-02', N'2020-03-29', N'2020-04-17');
INSERT INTO dbo.ReportingPeriod (Id, Type, Period, PeriodStart, PeriodEnd, DueAt) VALUES (10951, 0, N'2020-04-01', N'2020-03-30', N'2020-04-26', N'2020-05-15');
INSERT INTO dbo.ReportingPeriod (Id, Type, Period, PeriodStart, PeriodEnd, DueAt) VALUES (10952, 0, N'2020-05-01', N'2020-04-27', N'2020-05-31', N'2020-06-19');
INSERT INTO dbo.ReportingPeriod (Id, Type, Period, PeriodStart, PeriodEnd, DueAt) VALUES (10953, 0, N'2020-06-01', N'2020-06-01', N'2020-06-28', N'2020-07-17');