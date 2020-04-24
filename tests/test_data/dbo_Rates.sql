create table Rates
(
    Accredited bit,
    TitleI     bit,
    Region     varchar(max),
    AgeGroup   varchar(max),
    Time       varchar(max),
    Rate       float,
    RegionId   int,
    AgeGroupID int,
    TimeID     int
)
go

INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (0, 0, N'East', N'Infant/Toddler', N'FT', 148.73, 0, 0, 0);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (0, 0, N'East', N'Infant/Toddler', N'PT', 52.1, 0, 0, 1);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (0, 0, N'East', N'Preschool', N'FT', 126.59, 0, 1, 0);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (0, 0, N'East', N'Preschool', N'PT', 44.2, 0, 1, 1);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (0, 0, N'East', N'School-age', N'FT', 99.05, 0, 2, 0);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (0, 0, N'East', N'School-age', N'PT', 47.95, 0, 2, 1);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (0, 0, N'NorthCentral', N'Infant/Toddler', N'FT', 148.73, 1, 0, 0);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (0, 0, N'NorthCentral', N'Infant/Toddler', N'PT', 52.1, 1, 0, 1);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (0, 0, N'NorthCentral', N'Preschool', N'FT', 126.59, 1, 1, 0);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (0, 0, N'NorthCentral', N'Preschool', N'PT', 44.2, 1, 1, 1);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (0, 0, N'NorthCentral', N'School-age', N'FT', 99.75, 1, 2, 0);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (0, 0, N'NorthCentral', N'School-age', N'PT', 48.48, 1, 2, 1);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (0, 0, N'NorthWest', N'Infant/Toddler', N'FT', 148.73, 2, 0, 0);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (0, 0, N'NorthWest', N'Infant/Toddler', N'PT', 52.1, 2, 0, 1);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (0, 0, N'NorthWest', N'Preschool', N'FT', 126.59, 2, 1, 0);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (0, 0, N'NorthWest', N'Preschool', N'PT', 44.2, 2, 1, 1);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (0, 0, N'NorthWest', N'School-age', N'FT', 102.03, 2, 2, 0);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (0, 0, N'NorthWest', N'School-age', N'PT', 49.44, 2, 2, 1);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (0, 0, N'SouthCentral', N'Infant/Toddler', N'FT', 153.16, 3, 0, 0);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (0, 0, N'SouthCentral', N'Infant/Toddler', N'PT', 53.5, 3, 0, 1);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (0, 0, N'SouthCentral', N'Preschool', N'FT', 126.59, 3, 1, 0);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (0, 0, N'SouthCentral', N'Preschool', N'PT', 44.2, 3, 1, 1);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (0, 0, N'SouthCentral', N'School-age', N'FT', 99.05, 3, 2, 0);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (0, 0, N'SouthCentral', N'School-age', N'PT', 47.95, 3, 2, 1);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (0, 0, N'SouthWest', N'Infant/Toddler', N'FT', 179.43, 4, 0, 0);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (0, 0, N'SouthWest', N'Infant/Toddler', N'PT', 62.7, 4, 0, 1);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (0, 0, N'SouthWest', N'Preschool', N'FT', 126.59, 4, 1, 0);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (0, 0, N'SouthWest', N'Preschool', N'PT', 44.2, 4, 1, 1);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (0, 0, N'SouthWest', N'School-age', N'FT', 105.7, 4, 2, 0);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (0, 0, N'SouthWest', N'School-age', N'PT', 51.28, 4, 2, 1);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (0, 1, N'East', N'Infant/Toddler', N'FT', 167.38, 0, 0, 0);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (0, 1, N'East', N'Infant/Toddler', N'PT', 58.5, 0, 0, 1);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (0, 1, N'East', N'Preschool', N'FT', 126.59, 0, 1, 0);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (0, 1, N'East', N'Preschool', N'PT', 44.2, 0, 1, 1);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (0, 1, N'East', N'School-age', N'FT', 110.34, 0, 2, 0);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (0, 1, N'East', N'School-age', N'PT', 53.46, 0, 2, 1);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (0, 1, N'NorthCentral', N'Infant/Toddler', N'FT', 167.38, 1, 0, 0);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (0, 1, N'NorthCentral', N'Infant/Toddler', N'PT', 58.5, 1, 0, 1);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (0, 1, N'NorthCentral', N'Preschool', N'FT', 126.59, 1, 1, 0);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (0, 1, N'NorthCentral', N'Preschool', N'PT', 44.2, 1, 1, 1);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (0, 1, N'NorthCentral', N'School-age', N'FT', 111.3, 1, 2, 0);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (0, 1, N'NorthCentral', N'School-age', N'PT', 53.99, 1, 2, 1);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (0, 1, N'NorthWest', N'Infant/Toddler', N'FT', 167.38, 2, 0, 0);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (0, 1, N'NorthWest', N'Infant/Toddler', N'PT', 58.5, 2, 0, 1);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (0, 1, N'NorthWest', N'Preschool', N'FT', 126.59, 2, 1, 0);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (0, 1, N'NorthWest', N'Preschool', N'PT', 44.2, 2, 1, 1);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (0, 1, N'NorthWest', N'School-age', N'FT', 113.75, 2, 2, 0);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (0, 1, N'NorthWest', N'School-age', N'PT', 55.13, 2, 2, 1);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (0, 1, N'SouthCentral', N'Infant/Toddler', N'FT', 172.32, 3, 0, 0);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (0, 1, N'SouthCentral', N'Infant/Toddler', N'PT', 60.3, 3, 0, 1);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (0, 1, N'SouthCentral', N'Preschool', N'FT', 126.59, 3, 1, 0);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (0, 1, N'SouthCentral', N'Preschool', N'PT', 44.2, 3, 1, 1);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (0, 1, N'SouthCentral', N'School-age', N'FT', 110.34, 3, 2, 0);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (0, 1, N'SouthCentral', N'School-age', N'PT', 53.46, 3, 2, 1);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (0, 1, N'SouthWest', N'Infant/Toddler', N'FT', 201.67, 4, 0, 0);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (0, 1, N'SouthWest', N'Infant/Toddler', N'PT', 70.5, 4, 0, 1);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (0, 1, N'SouthWest', N'Preschool', N'FT', 126.59, 4, 1, 0);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (0, 1, N'SouthWest', N'Preschool', N'PT', 44.2, 4, 1, 1);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (0, 1, N'SouthWest', N'School-age', N'FT', 118.13, 4, 2, 0);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (0, 1, N'SouthWest', N'School-age', N'PT', 57.23, 4, 2, 1);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (1, 0, N'East', N'Infant/Toddler', N'FT', 169.95, 0, 0, 0);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (1, 0, N'East', N'Infant/Toddler', N'PT', 59.5, 0, 0, 1);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (1, 0, N'East', N'Preschool', N'FT', 165.32, 0, 1, 0);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (1, 0, N'East', N'Preschool', N'PT', 57.85, 0, 1, 1);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (1, 0, N'East', N'School-age', N'FT', 113.2, 0, 2, 0);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (1, 0, N'East', N'School-age', N'PT', 54.8, 0, 2, 1);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (1, 0, N'NorthCentral', N'Infant/Toddler', N'FT', 169.95, 1, 0, 0);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (1, 0, N'NorthCentral', N'Infant/Toddler', N'PT', 59.5, 1, 0, 1);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (1, 0, N'NorthCentral', N'Preschool', N'FT', 165.32, 1, 1, 0);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (1, 0, N'NorthCentral', N'Preschool', N'PT', 57.85, 1, 1, 1);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (1, 0, N'NorthCentral', N'School-age', N'FT', 114, 1, 2, 0);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (1, 0, N'NorthCentral', N'School-age', N'PT', 55.4, 1, 2, 1);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (1, 0, N'NorthWest', N'Infant/Toddler', N'FT', 169.95, 2, 0, 0);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (1, 0, N'NorthWest', N'Infant/Toddler', N'PT', 59.5, 2, 0, 1);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (1, 0, N'NorthWest', N'Preschool', N'FT', 165.32, 2, 1, 0);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (1, 0, N'NorthWest', N'Preschool', N'PT', 57.85, 2, 1, 1);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (1, 0, N'NorthWest', N'School-age', N'FT', 116.6, 2, 2, 0);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (1, 0, N'NorthWest', N'School-age', N'PT', 56.5, 2, 2, 1);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (1, 0, N'SouthCentral', N'Infant/Toddler', N'FT', 175, 3, 0, 0);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (1, 0, N'SouthCentral', N'Infant/Toddler', N'PT', 61.1, 3, 0, 1);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (1, 0, N'SouthCentral', N'Preschool', N'FT', 165.32, 3, 1, 0);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (1, 0, N'SouthCentral', N'Preschool', N'PT', 57.85, 3, 1, 1);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (1, 0, N'SouthCentral', N'School-age', N'FT', 113.2, 3, 2, 0);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (1, 0, N'SouthCentral', N'School-age', N'PT', 54.8, 3, 2, 1);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (1, 0, N'SouthWest', N'Infant/Toddler', N'FT', 205.07, 4, 0, 0);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (1, 0, N'SouthWest', N'Infant/Toddler', N'PT', 71.8, 4, 0, 1);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (1, 0, N'SouthWest', N'Preschool', N'FT', 165.32, 4, 1, 0);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (1, 0, N'SouthWest', N'Preschool', N'PT', 57.85, 4, 1, 1);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (1, 0, N'SouthWest', N'School-age', N'FT', 120.8, 4, 2, 0);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (1, 0, N'SouthWest', N'School-age', N'PT', 58.6, 4, 2, 1);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (1, 1, N'East', N'Infant/Toddler', N'FT', 191.27, 0, 0, 0);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (1, 1, N'East', N'Infant/Toddler', N'PT', 66.8, 0, 0, 1);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (1, 1, N'East', N'Preschool', N'FT', 165.32, 0, 1, 0);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (1, 1, N'East', N'Preschool', N'PT', 57.85, 0, 1, 1);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (1, 1, N'East', N'School-age', N'FT', 126.1, 0, 2, 0);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (1, 1, N'East', N'School-age', N'PT', 61.1, 0, 2, 1);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (1, 1, N'NorthCentral', N'Infant/Toddler', N'FT', 191.27, 1, 0, 0);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (1, 1, N'NorthCentral', N'Infant/Toddler', N'PT', 66.8, 1, 0, 1);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (1, 1, N'NorthCentral', N'Preschool', N'FT', 165.32, 1, 1, 0);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (1, 1, N'NorthCentral', N'Preschool', N'PT', 57.85, 1, 1, 1);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (1, 1, N'NorthCentral', N'School-age', N'FT', 127.2, 1, 2, 0);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (1, 1, N'NorthCentral', N'School-age', N'PT', 61.7, 1, 2, 1);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (1, 1, N'NorthWest', N'Infant/Toddler', N'FT', 191.27, 2, 0, 0);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (1, 1, N'NorthWest', N'Infant/Toddler', N'PT', 66.8, 2, 0, 1);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (1, 1, N'NorthWest', N'Preschool', N'FT', 165.32, 2, 1, 0);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (1, 1, N'NorthWest', N'Preschool', N'PT', 57.85, 2, 1, 1);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (1, 1, N'NorthWest', N'School-age', N'FT', 130, 2, 2, 0);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (1, 1, N'NorthWest', N'School-age', N'PT', 63, 2, 2, 1);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (1, 1, N'SouthCentral', N'Infant/Toddler', N'FT', 196.94, 3, 0, 0);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (1, 1, N'SouthCentral', N'Infant/Toddler', N'PT', 68.9, 3, 0, 1);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (1, 1, N'SouthCentral', N'Preschool', N'FT', 165.32, 3, 1, 0);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (1, 1, N'SouthCentral', N'Preschool', N'PT', 57.85, 3, 1, 1);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (1, 1, N'SouthCentral', N'School-age', N'FT', 126.1, 3, 2, 0);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (1, 1, N'SouthCentral', N'School-age', N'PT', 61.1, 3, 2, 1);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (1, 1, N'SouthWest', N'Infant/Toddler', N'FT', 230.51, 4, 0, 0);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (1, 1, N'SouthWest', N'Infant/Toddler', N'PT', 80.5, 4, 0, 1);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (1, 1, N'SouthWest', N'Preschool', N'FT', 165.32, 4, 1, 0);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (1, 1, N'SouthWest', N'Preschool', N'PT', 57.85, 4, 1, 1);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (1, 1, N'SouthWest', N'School-age', N'FT', 135, 4, 2, 0);
INSERT INTO dbo.Rates (Accredited, TitleI, Region, AgeGroup, Time, Rate, RegionId, AgeGroupID, TimeID) VALUES (1, 1, N'SouthWest', N'School-age', N'PT', 65.4, 4, 2, 1);