from datetime import date, timedelta
from ece_extraction.table_extraction import add_new_reports

if __name__ == '__main__':

    # Get all reports submitted yesterday
    yesterday = date.today() - timedelta(days=1)
    today = date.today()
    add_new_reports(start_date=yesterday, end_date=today)
