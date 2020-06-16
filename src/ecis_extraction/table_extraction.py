import os
import numpy as np
import pandas as pd
from datetime import datetime
from sqlalchemy.sql import text
from resource_access.constants import ECIS_DB_SECTION
from resource_access.connections import get_mysql_connection
from analytic_tables.conversion_functions import get_beginning_and_end_of_month
from analytic_tables.base_tables import MonthlyOrganizationRevenueReporting, MonthlyEnrollmentReporting, \
    MonthlyOrganizationSpaceReporting

DATA_DB = get_mysql_connection(ECIS_DB_SECTION)
ECIS_DIR = os.path.dirname(__file__)
ENROLLMENT_QUERY_FILE = ECIS_DIR + '/sql/functions/ecis_enrollment_extraction.sql'


def load_month_of_reports(month: datetime.date) -> None:
    """
    Pull enrollments for a month, transform them and load the resulting dataframe to the database
    :param month: Month for which data will be pulled and loaded
    :return: None
    """
    enrollment_df = get_raw_enrollment_df(month=month)
    print(f"Data Extracted from ECIS for month containing {month}")
    transformed_enrollment_df = transform_enrollment_df(enrollment_df)
    print(f"Enrollment data transformed")
    transformed_enrollment_df.to_sql(name=MonthlyEnrollmentReporting.__tablename__,
                                     con=DATA_DB, if_exists='append', index=False)
    print(f"Enrollment data loaded to database for month{month}")


def get_raw_enrollment_df(month: datetime.date) -> pd.DataFrame:
    """
    Pulls all records in ECIS that were active during the month of the date that is passed
    :param month:
    :return: dataframe of enrollments for the given month
    """
    start_date, end_date = get_beginning_and_end_of_month(month)
    parameters = {'start_date': start_date, 'end_date': end_date}
    df = pd.read_sql(sql=text(open(ENROLLMENT_QUERY_FILE).read()), params=parameters, con=DATA_DB)
    return df


def transform_enrollment_df(enrollment_df: pd.DataFrame) -> pd.DataFrame:

    # Convert for foster families
    foster_col = np.where(enrollment_df['AddressType'] == 'Foster Parent', 1, 0)

    # Validate and 
    enrollment_df[MonthlyEnrollmentReporting.Foster.name] == foster_col
    pass
