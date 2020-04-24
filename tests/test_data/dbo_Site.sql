create table Site
(
    Id             int identity
        constraint PK_Site
            primary key,
    Name           nvarchar(100) not null,
    TitleI         bit           not null,
    Region         int           not null,
    OrganizationId int           not null,
    FacilityCode   int,
    LicenseNumber  int,
    NaeycId        int,
    RegistryId     int
)
go

create index IX_Site_OrganizationId
    on Site (OrganizationId)
go

SET IDENTITY_INSERT SITE ON
INSERT INTO dbo.Site (Id, Name, TitleI, Region, OrganizationId, FacilityCode, LicenseNumber, NaeycId, RegistryId) VALUES (1072, N'Gryffindor Day Care Center', 0, 0, 886, null, null, null, null);
INSERT INTO dbo.Site (Id, Name, TitleI, Region, OrganizationId, FacilityCode, LicenseNumber, NaeycId, RegistryId) VALUES (1073, N'Helga Hufflepuff Day Care', 0, 0, 886, null, null, null, null);
INSERT INTO dbo.Site (Id, Name, TitleI, Region, OrganizationId, FacilityCode, LicenseNumber, NaeycId, RegistryId) VALUES (1074, N'Honey Pot', 0, 0, 887, null, null, null, null);