import pandas as pd
from ecis_extraction.table_extraction import load_month_of_reports

# Beginning of FY 2014-2015, a chunk of records start here, validate ideal start time
START_DATE = '2014-07-01'
# Date of ECIS snapshot
END_DATE = '2020-02-26'

if __name__ == '__main__':
    for month in pd.date_range(START_DATE, END_DATE, freq='MS').tolist():
        load_month_of_reports(month)
