create table Organization
(
    Id   int identity
        constraint PK_Organization
            primary key,
    Name nvarchar(100) not null
)
go

SET IDENTITY_INSERT Organization ON
INSERT INTO dbo.Organization (Id, Name) VALUES (886, N'Hogwarts Child Development Center, Inc.');
INSERT INTO dbo.Organization (Id, Name) VALUES (887, N'Honey Pot');