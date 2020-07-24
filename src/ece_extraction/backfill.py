import os
import pandas as pd
from resource_access.constants import ECE_DB_SECTION
from resource_access.connections import get_mysql_connection
from ece_extraction.table_extraction import extract_ece_data, get_reports, get_month_of_reports, process_ece_s3_data

START_DATE = '2020-01-01'
END_DATE = '2020-06-30'

if __name__ == '__main__':

    os.environ['stage'] = 'prod'

    for month in pd.date_range(START_DATE, END_DATE, freq='MS').tolist():

        # Load all previous months of reports to S3
        report_df = get_month_of_reports(month)
        for _, report in report_df.iterrows():
            extract_ece_data(report)

        # Pull loaded data from S3 and write to Pensieve
        process_ece_s3_data(month)