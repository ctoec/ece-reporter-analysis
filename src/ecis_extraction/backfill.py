import pandas as pd
from ecis_extraction.table_extraction import load_month_of_reports

# Beginning of SY 2016-2017, a chunk of records start here
START_DATE = '2017-02-01'
# Date of ECIS snapshot
END_DATE = '2020-02-26'

if __name__ == '__main__':
    for month in pd.date_range(START_DATE, END_DATE, freq='MS').tolist():
        load_month_of_reports(month)
