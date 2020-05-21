import os
import sqlalchemy
import pandas as pd
from datetime import datetime
from sqlalchemy.sql import text
from resource_access.constants import ECE_DB_SECTION
from resource_access.connections import get_mysql_connection
from analytic_tables.MonthlyEnrollmentReporting import MonthlyEnrollmentReporting
from analytic_tables.MonthlyOrganizationSpaceReporting import MonthlyOrganizationSpaceReporting
from analytic_tables.MonthlyOrganizationRevenueReporting import MonthlyOrganizationRevenueReporting

ENROLLMENT_QUERY_FILE = os.path.dirname(__file__) + '/sql/functions/cdc_enrollment.sql'
DATA_DB = get_mysql_connection(ECE_DB_SECTION)
# TKTKTKTK penseive creds
# ANALYSIS_DB = get_mysql_connection(PENSIEVE_SECTION)


def process_report(report: pd.Series) -> None:
    """
    Pulls all data associated with a report. Datasets pulled are enrollments, spaces and revenue. Data is transformed,
    cleaned and loaded to analytics tables
    :param report: pandas row with metadata about a Report
    :return: None, data is loaded to the DB
    """
    # Pull raw enrollment data and transform it
    raw_enrollment_df = get_raw_enrollments(report)
    transformed_enrollment_df = transform_enrollment_df(raw_enrollment_df)

    # Pull raw space data, combine it with enrollments and transform it
    raw_space_df = get_raw_spaces(report)
    transformed_space_df = transform_space_df(raw_space_df, transformed_enrollment_df)

    # Pull raw revenue data, combine it with space data and transform
    raw_revenue_df = get_raw_revenue(report)
    transformed_revenue_df = transform_revenue_df(raw_revenue_df, transformed_space_df)

    # Append transformed dataframe to their matching tables
    transformed_enrollment_df.to_sql(name=MonthlyEnrollmentReporting.__tablename__,
                                     con=DATA_DB, if_exists='append', index=False)
    transformed_space_df.to_sql(name=MonthlyOrganizationSpaceReporting.__tablename__,
                                con=DATA_DB, if_exists='append', index=False)
    transformed_revenue_df.to_sql(name=MonthlyOrganizationRevenueReporting.__tablename__,
                                  con=DATA_DB, if_exists='append', index=False)


def add_new_reports(start_date: datetime.timestamp):
    """
    Add all new reports since called start date to analytical tables
    :param start_date: timestamp, all reports since this time, inclusive of the start time will be added
    :return: None
    """
    report_df = get_reports(start_date)
    for _, report in report_df.iterrows():
        print(f"Report ID {report.Id} processing")
        process_report(report)
        print(f"Report ID {report.Id} done with processing")


def transform_space_df(raw_space_df: pd.DataFrame, transformed_enrollment_df: pd.DataFrame) -> pd.DataFrame:
    pass


def transform_enrollment_df(enrollment_df: pd.DataFrame) -> pd.DataFrame:
    pass


def transform_revenue_df(raw_revenue_df: pd.DataFrame, transformed_space_df: pd.DataFrame) -> pd.DataFrame:
    pass


def get_reports(start_date: datetime.timestamp) -> pd.DataFrame:
    """
    Returns dataframe of reports that were submitted since the provided start time
    :param start_date: First date (inclusive) of reports to pull, pulls all reports from this date to current time
    :return: new_reports: Dataframe with each row with the metadata of the report to load
    """
    query = text("SELECT Id, SubmittedAt FROM Report WHERE SubmittedAt >= :start_date")
    new_reports = pd.read_sql(sql=query, params={'start_date': start_date}, con=DB)

    return new_reports


def get_raw_enrollments(report: pd.Series) -> pd.DataFrame:
    """
    Call cdc_enrollment.sql script with report metadata (SubmittedAt and Id) to get related Enrollments
    :param report: pandas series associated with a single report, Id and SubmittedAt are included
    :return: dataframe with all enrollments associated with a report
    """

    parameters = {'system_time': report.SubmittedAt, 'report_id': report.Id}
    df = pd.read_sql(text(open(ENROLLMENT_QUERY_FILE).read()), params=parameters, con=DB)

    return df

def get_raw_spaces(report: pd.Series) -> pd.DataFrame:
    pass

def get_raw_revenue(report: pd.Series) -> pd.DataFrame:
    pass




