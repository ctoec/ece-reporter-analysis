from datetime import date, timedelta
from ece_extraction.table_extraction import process_ece_s3_data


if __name__ == '__main__':

    last_month = date.today().replace(day=1) - timedelta(days=1)

    # Download all extracted reports, transform and load to Pensieve
    process_ece_s3_data(last_month)
