from sqlalchemy.dialects import mssql
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Column, Integer, DateTime, Numeric, String

ANALYTIC_TABLE_BASE = declarative_base()


class MonthlyEnrollmentReporting(ANALYTIC_TABLE_BASE):
    __tablename__ = 'MonthlyEnrollmentReporting'

    ChildId = Column(mssql.UNIQUEIDENTIFIER, primary_key=True)
    OrganizationId = Column(Integer)
    OrganizationName = Column(mssql.VARCHAR(100))
    SiteId = Column(Integer)
    SiteName = Column(mssql.VARCHAR(100))
    EnrollmentId = Column(Integer, primary_key=True)
    FamilyDeterminationId = Column(Integer)
    FamilyId = Column(Integer)
    ReportingPeriodId = Column(Integer, primary_key=True)
    ReportId = Column(Integer, primary_key=True)
    Period = Column(mssql.VARCHAR(25))
    ReportingPeriodStart = Column(DateTime)
    ReportingPeriodEnd = Column(DateTime)
    Sasid = Column(mssql.VARCHAR)
    LastName = Column(mssql.VARCHAR(250))
    FirstName = Column(mssql.VARCHAR(250))
    AgeGroupName = Column(mssql.VARCHAR(50))
    TimeName = Column(mssql.VARCHAR(5))
    SiteLicenseNumber = Column(Integer)
    RegionName = Column(mssql.VARCHAR(50))
    TitleI = Column(mssql.BIT)
    Entry = Column(DateTime)
    Exit = Column(DateTime)
    FamilySize = Column(Integer)
    Income = Column(Numeric)
    AmericanIndianOrAlaskaNative = Column(mssql.BIT)
    Asian = Column(mssql.BIT)
    BlackOrAfricanAmerican = Column(mssql.BIT)
    NativeHawaiianOrPacificIslander = Column(mssql.BIT)
    White = Column(mssql.BIT)
    TwoOrMoreRaces = Column(mssql.BIT)
    HispanicOrLatinxEthnicity = Column(mssql.BIT)
    Gender = Column(mssql.BIT)
    Foster = Column(mssql.BIT)
    Accredited = Column(mssql.BIT)
    Rate = Column(mssql.DECIMAL(18, 2))
    CDCRevenue = Column(mssql.DECIMAL(18, 2))
    FundingSource = Column(Integer, primary_key=True)
    SMI75 = Column(Integer)
    FPL200 = Column(Integer)
    Under75SMI = Column(mssql.BIT)
    Under200FPL = Column(mssql.BIT)
    ActiveC4K = Column(mssql.BIT)


class MonthlyOrganizationSpaceReporting(ANALYTIC_TABLE_BASE):
    __tablename__ = 'MonthlyOrganizationSpaceReporting'

    ReportingPeriodId = Column(Integer, primary_key=True)
    ReportId = Column(Integer)
    Period = Column(mssql.VARCHAR(25))
    ReportingPeriodStart = Column(DateTime)
    ReportingPeriodEnd = Column(DateTime)
    Accredited = Column(mssql.BIT)
    ReportFundingSourceType = Column(Integer, primary_key=True)
    OrganizationId = Column(Integer, primary_key=True)
    OrganizationName = Column(mssql.VARCHAR(200))
    Capacity = Column(Integer)
    TimeName = Column(mssql.VARCHAR(20), primary_key=True)
    AgeGroupName = Column(mssql.VARCHAR(20), primary_key=True)
    UtilizedSpaces = Column(Integer)
    UtilizedTitleISpaces = Column(Integer)
    UtilizedNonTitle1Spaces = Column(Integer)
    CDCRevenue = Column(mssql.DECIMAL(18, 2))


class MonthlyOrganizationRevenueReporting(ANALYTIC_TABLE_BASE):
    __tablename__ = 'MonthlyOrganizationRevenueReporting'
    ReportingPeriodId = Column(Integer, primary_key=True)
    ReportId = Column(Integer)
    Period = Column(mssql.VARCHAR(25))
    ReportingPeriodStart = Column(DateTime)
    ReportingPeriodEnd = Column(DateTime)
    Accredited = Column(mssql.BIT)
    OrganizationId = Column(Integer, primary_key=True)
    OrganizationName = Column(String)
    RetroactiveC4KRevenue = Column(mssql.BIT)
    FamilyFeesRevenue = Column(mssql.DECIMAL(18, 2))
    C4KRevenue = Column(mssql.DECIMAL(18, 2))
    CDCRevenue = Column(mssql.DECIMAL(18, 2))
    TotalCapacity = Column(Integer)
    UtilizedSpaces = Column(Integer)