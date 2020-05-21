from sqlalchemy.dialects import mssql
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Column, Integer, DateTime

Base = declarative_base()


class MonthlyOrganizationSpaceReporting(Base):

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
