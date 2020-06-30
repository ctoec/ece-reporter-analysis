from datetime import datetime
from sqlalchemy.dialects import mssql
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Column, Integer, DateTime, Numeric, String, UniqueConstraint

ANALYTIC_TABLE_BASE = declarative_base()

## TODO
# Add in deduping of organizations and matching of sites and orgs


class MonthlyEnrollmentReporting(ANALYTIC_TABLE_BASE):

    # Standardized names
    MONTH = 'Month'
    MALE = 'M'
    FEMALE = 'F'
    CDC_SOURCE = 'CDC'
    STATE_HEAD_START = 'State Head Start'
    SMART_START = 'Smart Start'
    HEAD_START = 'Head Start'
    PDG_FEDERAL = 'PDG Federal'
    SCHOOL_READINESS_PRIORITY = 'School Readiness - Priority'
    PDG_STATE = 'PDG State'
    PRIVATE_PAY = 'Private Pay'
    SCHOOL_READINESS_COMPETITIVE = 'School Readiness – Competitive'

    __tablename__ = 'MonthlyEnrollmentReporting'

    Id = Column(Integer, primary_key=True)
    SourceSystem = Column(mssql.VARCHAR(100))
    SourceChildId = Column(mssql.VARCHAR(100))
    SourceOrganizationId = Column(Integer)
    OrganizationName = Column(mssql.VARCHAR(100))
    SourceSiteId = Column(Integer)
    SiteName = Column(mssql.VARCHAR(100))
    FacilityCode = Column(Integer)
    EnrollmentId = Column(Integer)
    FamilyDeterminationId = Column(Integer)
    FamilyId = Column(Integer)
    ReportId = Column(Integer)
    Period = Column(DateTime)
    PeriodType = Column(mssql.VARCHAR(25))
    PeriodStart = Column(DateTime)
    PeriodEnd = Column(DateTime)
    Sasid = Column(mssql.VARCHAR(None))
    BirthCertificateId = Column(mssql.VARCHAR(None))
    StateOfBirth = Column(mssql.VARCHAR(10))
    TownOfBirth = Column(mssql.VARCHAR(None))
    LastName = Column(mssql.VARCHAR(250))
    MiddleName = Column(mssql.VARCHAR(250))
    FirstName = Column(mssql.VARCHAR(250))
    BirthDate = Column(DateTime)
    Town = Column(mssql.VARCHAR(None))
    ZipCode = Column(mssql.VARCHAR(None))
    State = Column(mssql.VARCHAR(None))
    CombinedAddress = Column(mssql.VARCHAR(None))
    CDCAgeGroupName = Column(mssql.VARCHAR(50))
    CDCTimeName = Column(mssql.VARCHAR(50))
    SpaceType = Column(mssql.VARCHAR(50))
    SpaceTypeSubcategory = Column(mssql.VARCHAR(100))
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
    Gender = Column(mssql.VARCHAR(25))
    Foster = Column(mssql.BIT)
    HasIEP = Column(mssql.BIT)
    Accredited = Column(mssql.BIT)
    Rate = Column(mssql.DECIMAL(18, 2))
    CDCRevenue = Column(mssql.DECIMAL(18, 2))
    FundingSource = Column(mssql.VARCHAR(50))
    SMI75 = Column(Integer)
    FPL200 = Column(Integer)
    Under75SMI = Column(mssql.BIT)
    Under200FPL = Column(mssql.BIT)
    ActiveC4K = Column(mssql.BIT)
    TimeInserted = Column(DateTime, default=datetime.now())
    TimeUpdated = Column(DateTime, default=datetime.now(), onupdate=datetime.now())
    UniqueConstraint('SourceChildId', 'EnrollmentId', 'Period', 'PeriodType', 'FundingSource', name='unique_enroll_idx_1')


class MonthlyOrganizationSpaceReporting(ANALYTIC_TABLE_BASE):
    MONTH = 'Month'
    __tablename__ = 'MonthlyOrganizationSpaceReporting'

    Id = Column(Integer, primary_key=True)
    ReportId = Column(Integer)
    Period = Column(mssql.VARCHAR(25))
    PeriodType = Column(mssql.VARCHAR(25))
    PeriodStart = Column(DateTime)
    PeriodEnd = Column(DateTime)
    Accredited = Column(mssql.BIT)
    ReportFundingSourceType = Column(mssql.VARCHAR(50))
    SourceOrganizationId = Column(Integer)
    OrganizationName = Column(mssql.VARCHAR(200))
    Capacity = Column(Integer)
    CDCTimeName = Column(mssql.VARCHAR(20))
    CDCAgeGroupName = Column(mssql.VARCHAR(20))
    SpaceType = Column(mssql.VARCHAR(50))
    UtilizedSpaces = Column(Integer)
    UtilizedTitleISpaces = Column(Integer)
    UtilizedNonTitle1Spaces = Column(Integer)
    CDCRevenue = Column(mssql.DECIMAL(18, 2))
    TimeInserted = Column(DateTime, default=datetime.now())
    TimeUpdated = Column(DateTime, default=datetime.now(), onupdate=datetime.now())
    UniqueConstraint('Period', 'PeriodType', 'SourceOrganizationId', 'ReportFundingSourceType', 'SpaceType', name='unique_space_idx_1')


class MonthlyOrganizationRevenueReporting(ANALYTIC_TABLE_BASE):
    MONTH = 'Month'
    __tablename__ = 'MonthlyOrganizationRevenueReporting'

    Id = Column(Integer, primary_key=True)
    ReportId = Column(Integer)
    Period = Column(DateTime)
    PeriodType = Column(mssql.VARCHAR(25))
    PeriodStart = Column(DateTime)
    PeriodEnd = Column(DateTime)
    Accredited = Column(mssql.BIT)
    SourceOrganizationId = Column(Integer)
    OrganizationName = Column(String)
    RetroactiveC4KRevenue = Column(mssql.BIT)
    FamilyFeesRevenue = Column(mssql.DECIMAL(18, 2))
    C4KRevenue = Column(mssql.DECIMAL(18, 2))
    CDCRevenue = Column(mssql.DECIMAL(18, 2))
    TotalCapacity = Column(Integer)
    UtilizedSpaces = Column(Integer)
    ReportFundingSourceType = Column(mssql.VARCHAR(50))
    TimeInserted = Column(DateTime, default=datetime.now())
    TimeUpdated = Column(DateTime, default=datetime.now(), onupdate=datetime.now())
    UniqueConstraint('Period', 'PeriodType', 'SourceOrganizationId', 'ReportFundingSourceType', name='unique_org_rev_idx_1')
