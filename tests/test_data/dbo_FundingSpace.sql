create table FundingSpace
(
    Id             int identity
        constraint PK_FundingSpace
            primary key,
    Capacity       int not null,
    OrganizationId int not null,
    Source         int not null,
    AgeGroup       int not null,
    Time           int not null
)
go

create index IX_FundingSpace_OrganizationId
    on FundingSpace (OrganizationId)
go
SET IDENTITY_INSERT FundingSpace ON
INSERT INTO dbo.FundingSpace (Id, Capacity, OrganizationId, Source, AgeGroup, Time) VALUES (1164, 10, 886, 0, 0, 0);
INSERT INTO dbo.FundingSpace (Id, Capacity, OrganizationId, Source, AgeGroup, Time) VALUES (1165, 20, 886, 0, 1, 1);
INSERT INTO dbo.FundingSpace (Id, Capacity, OrganizationId, Source, AgeGroup, Time) VALUES (1166, 10, 887, 0, 0, 0);