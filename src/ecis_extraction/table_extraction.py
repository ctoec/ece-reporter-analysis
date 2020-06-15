from datetime import datetime
from resource_access.connections import get_mysql_connection
from resource_access.constants import ECIS_DB_SECTION

DATA_DB = get_mysql_connection(ECIS_DB_SECTION)


def get_time_range(start_date, end_date, program_type):
    """
    Gets the timerange for analysis for a particular
    :param start_date:
    :param end_date:
    :param program_type:
    :return:
    """

