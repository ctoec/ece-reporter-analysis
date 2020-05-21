from sqlalchemy.dialects import mssql
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Column, Integer, String, DateTime

Base = declarative_base()


class MonthlyOrganizationRevenueReporting(Base):

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
