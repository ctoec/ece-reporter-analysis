from datetime import date, timedelta
from ece_extraction.table_extraction import extract_ece_data, get_month_of_reports

if __name__ == '__main__':
    # Get the last day of last month
    last_month = date.today().replace(day=1) - timedelta(days=1)

    # Get all reports submitted last month and write results to S3
    report_df = get_month_of_reports(last_month)
    for _, report in report_df.iterrows():
        extract_ece_data(report)
