create table FundingTimeAllocation
(
    Id             int identity
        constraint PK_FundingTimeAllocation
            primary key,
    FundingSpaceId int not null
        constraint FK_FundingTimeAllocation_FundingSpace_FundingSpaceId
            references FundingSpace
            on delete cascade,
    Weeks          int not null,
    Time           int not null
)
go
SET IDENTITY_INSERT FundingTimeAllocation ON
create index IX_FundingTimeAllocation_FundingSpaceId
    on FundingTimeAllocation (FundingSpaceId)
go

INSERT INTO dbo.FundingTimeAllocation (Id, FundingSpaceId, Weeks, Time) VALUES (43, 1164, 52, 0);
INSERT INTO dbo.FundingTimeAllocation (Id, FundingSpaceId, Weeks, Time) VALUES (44, 1165, 52, 0);
INSERT INTO dbo.FundingTimeAllocation (Id, FundingSpaceId, Weeks, Time) VALUES (45, 1166, 52, 0);