import unittest
from datetime import date, timedelta
from ece_extraction.table_extraction import get_reports, transform_and_load_report, get_raw_enrollments,\
    get_raw_revenue, get_raw_spaces
from resource_access.constants import ECE_DB_SECTION, PENSIEVE_DB_SECTION, ENROLLMENTS_FILE, SPACES_FILE, REVENUE_FILE
from resource_access.connections import get_mysql_connection


class TestReportExtraction(unittest.TestCase):

    def test_full_run(self):
        """
        Test extraction and loading while skipping load to S3 step
        :return:
        """
        today = date.today()
        tomorrow = date.today() + timedelta(days=1)
        data_db = get_mysql_connection(ECE_DB_SECTION)
        pensieve_db = get_mysql_connection(PENSIEVE_DB_SECTION)
        report_df = get_reports(start_date=today, end_date=tomorrow, db=data_db)
        for _, report in report_df.iterrows():
            df_dict = {}

            enrollment_df = get_raw_enrollments(report, db=data_db)
            space_df = get_raw_spaces(report, db=data_db)
            revenue_df = get_raw_revenue(report, db=data_db)

            df_dict[ENROLLMENTS_FILE] = enrollment_df
            df_dict[SPACES_FILE] = space_df
            df_dict[REVENUE_FILE] = revenue_df

            transform_and_load_report(df_dict=df_dict, pensieve_db=pensieve_db)


if __name__ == '__main__':
	unittest.main()