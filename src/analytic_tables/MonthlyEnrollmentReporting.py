from sqlalchemy.dialects import mssql
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Column, Integer, DateTime, Numeric

Base = declarative_base()


class MonthlyEnrollmentReporting(Base):

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
     Rate = Column(mssql.DECIMAL(18,2))
     CDCRevenue = Column(mssql.DECIMAL(18,2))
     FundingSource = Column(Integer, primary_key=True)
     SMI75 = Column(Integer)
     FPL200 = Column(Integer)
     Under75SMI = Column(mssql.BIT)
     Under200FPL = Column(mssql.BIT)
     ActiveC4K = Column(mssql.BIT)
