import os
import pandas as pd
from datetime import datetime
from sqlalchemy.sql import text
from resource_access.connections import get_mysql_connection
from resource_access.constants import ECIS_DB_SECTION

DATA_DB = get_mysql_connection(ECIS_DB_SECTION)
ECIS_DIR = os.path.dirname(__file__)
ENROLLMENT_QUERY_FILE = ECIS_DIR + '/sql/functions/cdc_enrollment.sql'


def load_month_of_reports(month: datetime.date) -> None:
    """
    Pull enrollments for a month, transform them and load the resulting dataframe to the database
    :param month: Month for which data will be pulled and loaded
    :return: None
    """
    enrollment_df = get_raw_enrollment_df(month=month)


def get_beginning_and_end_of_month(month: datetime.date):
    start = None
    end = None
    return start, end

def get_raw_enrollment_df(month: datetime.date) -> pd.DataFrame:
    """
    Pulls all records in ECIS that were active during the month of the date that is passed
    :param month:
    :return: dataframe of enrollments for the given month
    """
    start_date, end_date = get_beginning_and_end_of_month(month)
    parameters = {'start_date': start_date, 'end_date': end_date}
    df = pd.read_sql(sql=text(open(ENROLLMENT_QUERY_FILE).read()), params=parameters, con=DATA_DB)