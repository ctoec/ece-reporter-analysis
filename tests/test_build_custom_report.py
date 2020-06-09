import unittest
from datetime import date, timedelta
from ece_extraction.table_extraction import add_new_reports

class TestReportExtraction(unittest.TestCase):

    def test_full_run(self):
        """
        Load data with a full run in the database
        :return:
        """
        today = date.today()
        tomorrow = date.today() + timedelta(days=1)
        add_new_reports(start_date=today, end_date=tomorrow)


if __name__ == '__main__':
	unittest.main()