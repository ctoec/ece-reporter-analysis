import os
import numpy as np
import pandas as pd
from datetime import datetime
from sqlalchemy.sql import text
from resource_access.constants import ECE_DB_SECTION
from resource_access.connections import get_mysql_connection
from analytic_tables.conversion_functions import validate_and_convert_state
from analytic_tables.base_tables import MonthlyEnrollmentReporting, MonthlyOrganizationRevenueReporting, \
    MonthlyOrganizationSpaceReporting

ECE_DIR = os.path.dirname(__file__)
ENROLLMENT_QUERY_FILE = ECE_DIR + '/sql/functions/cdc_enrollment.sql'
SPACES_QUERY_FILE = ECE_DIR + '/sql/functions/cdc_spaces.sql'
REVENUE_QUERY_FILE = ECE_DIR + '/sql/functions/cdc_revenue.sql'

RATES_FILE = ECE_DIR + '/data/Rates.csv'
INCOME_LEVEL_FILE = ECE_DIR + '/data/IncomeLevels.csv'

DATA_DB = get_mysql_connection(ECE_DB_SECTION)

# TKTKTKTK penseive creds
# ANALYSIS_DB = get_mysql_connection(PENSIEVE_SECTION)


def process_report(report: pd.Series) -> None:
    """
    Pulls all data associated with a report. Datasets pulled are enrollments, spaces and revenue. Data is transformed,
    cleaned and loaded to analytics tables
    :param report: pandas row with metadata about a Report
    :return: None, data is loaded to the DB
    """
    # Pull raw enrollment data and transform it
    raw_enrollment_df = get_raw_enrollments(report)
    transformed_enrollment_df = transform_enrollment_df(raw_enrollment_df)

    # Write enrollment to analytics DB
    transformed_enrollment_df.to_sql(name=MonthlyEnrollmentReporting.__tablename__,
                                     con=DATA_DB, if_exists='append', index=False)

    # Pull raw space data, combine it with enrollments and transform it
    raw_space_df = get_raw_spaces(report)
    transformed_space_df = transform_space_df(raw_space_df, transformed_enrollment_df)

    # Write space capacity and utilization to database
    transformed_space_df.to_sql(name=MonthlyOrganizationSpaceReporting.__tablename__,
                                con=DATA_DB, if_exists='append', index=False)

    # Pull raw revenue data, combine it with space data and transform
    raw_revenue_df = get_raw_revenue(report)
    transformed_revenue_df = transform_revenue_df(raw_revenue_df, transformed_space_df)

    # Write revenue data to database
    transformed_revenue_df.to_sql(name=MonthlyOrganizationRevenueReporting.__tablename__,
                                  con=DATA_DB, if_exists='append', index=False)


def add_new_reports(start_date: datetime.timestamp, end_date: datetime.timestamp):
    """
    Add all new reports since called start date to analytical tables
    :param start_date: timestamp, reports after this time, inclusive of the start time will be added
    :param end_date: timestamp, all reports before this time and after start date will be added
    :return: None
    """
    report_df = get_reports(start_date, end_date)
    print(f"Processing {len(report_df)} report(s)")
    for _, report in report_df.iterrows():
        print(f"Report ID {report.Id} processing")
        process_report(report)
        print(f"Report ID {report.Id} done with processing")


def get_raw_enrollments(report: pd.Series) -> pd.DataFrame:
    """
    Call cdc_enrollment.sql script with report metadata (SubmittedAt and Id) to get related Enrollments
    :param report: pandas series associated with a single report, Id and SubmittedAt are included
    :return: dataframe with all enrollments associated with a report
    """

    parameters = {'system_time': report.SubmittedAt, 'report_id': report.Id}
    df = pd.read_sql(sql=text(open(ENROLLMENT_QUERY_FILE).read()), params=parameters, con=DATA_DB)

    return df


def transform_enrollment_df(enrollment_df: pd.DataFrame) -> pd.DataFrame:

    # Add new columns

    # Set family size to 1 for foster, leave as number of people for other
    family_size_col = np.where(enrollment_df[MonthlyEnrollmentReporting.Foster.name] == 1,
                               1, enrollment_df['NumberOfPeople'])
    enrollment_df[MonthlyEnrollmentReporting.FamilySize.name] = family_size_col

    # Overwrite income to 0 for foster children
    income_col = np.where(enrollment_df[MonthlyEnrollmentReporting.Foster.name] == 1,
                          1, enrollment_df['Income'])
    enrollment_df[MonthlyEnrollmentReporting.Income.name] = income_col

    # Add Income level booleans
    income_level_df = pd.read_csv(INCOME_LEVEL_FILE)
    enrollment_df = enrollment_df.merge(income_level_df,
                                       left_on=MonthlyEnrollmentReporting.FamilySize.name,
                                       right_on='NumberOfPeople')
    enrollment_df[MonthlyEnrollmentReporting.SMI75.name] = enrollment_df['x75SMI']
    enrollment_df[MonthlyEnrollmentReporting.Under75SMI.name] = np.where(enrollment_df.Income < enrollment_df.x75SMI,
                                                                         1, 0)
    enrollment_df[MonthlyEnrollmentReporting.FPL200.name] = enrollment_df['x200FPL']
    enrollment_df[MonthlyEnrollmentReporting.Under200FPL.name] = np.where(enrollment_df.Income < enrollment_df.x200FPL,
                                                                          1, 0)

    # Create a boolean column for children with two or more races
    race_cols = ['AmericanIndianOrAlaskaNative', 'Asian', 'BlackOrAfricanAmerican', 'NativeHawaiianOrPacificIslander', 'White']
    enrollment_df[MonthlyEnrollmentReporting.TwoOrMoreRaces.name] = np.where(enrollment_df[race_cols].sum(axis=1) > 1,
                                                                             1, 0)
    # Calculate monthly rate from number of weeks
    rates_df = pd.read_csv(RATES_FILE)
    enrollment_df['weeks'] = np.ceil((enrollment_df['PeriodEnd'] - enrollment_df['PeriodStart']) / np.timedelta64(1, 'W'))
    rate_col = enrollment_df.merge(rates_df,
                                   how='left',
                                   left_on=['Region', 'Accredited', 'TitleI', 'AgeGroup', 'Time'],
                                   right_on=['RegionId', 'Accredited', 'TitleI', 'AgeGroupId', 'TimeId'])['Rate']
    enrollment_df[MonthlyEnrollmentReporting.CDCRevenue.name] = enrollment_df['weeks'] * rate_col

    # Add column for active C4K
    start_cols = enrollment_df['StartDate'] <= enrollment_df['PeriodEnd']
    end_cols = (enrollment_df['EndDate'] >= enrollment_df['PeriodStart']) | enrollment_df['EndDate'].isnull()
    enrollment_df[MonthlyEnrollmentReporting.ActiveC4K.name] = start_cols & end_cols

    # Fill in times and age groups with text
    enrollment_df = replace_time_and_age_group_values(enrollment_df, 'Time', 'AgeGroup')

    # Validate and formalize state names
    enrollment_df['State'] = enrollment_df['State'].apply(validate_and_convert_state)
    # Rename columns
    rename_dict = {
        'ChildId': MonthlyEnrollmentReporting.SourceChildId.name,
        'OrganizationId': MonthlyEnrollmentReporting.OrganizationId.name,
        'OrganizationName': MonthlyEnrollmentReporting.OrganizationName.name,
        'SiteId': MonthlyEnrollmentReporting.SiteId.name,
        'SiteName': MonthlyEnrollmentReporting.SiteName.name,
        'EnrollmentId': MonthlyEnrollmentReporting.EnrollmentId.name,
        'FamilyDeterminationId': MonthlyEnrollmentReporting.FamilyDeterminationId.name,
        'FamilyId': MonthlyEnrollmentReporting.FamilyId.name,
        'ReportingPeriodId': MonthlyEnrollmentReporting.ReportingPeriodId.name,
        'ReportId': MonthlyEnrollmentReporting.ReportId.name,
        'Period': MonthlyEnrollmentReporting.Period.name,
        'PeriodStart': MonthlyEnrollmentReporting.ReportingPeriodStart.name,
        'PeriodEnd': MonthlyEnrollmentReporting.ReportingPeriodEnd.name,
        'Sasid': MonthlyEnrollmentReporting.Sasid.name,
        'LastName': MonthlyEnrollmentReporting.LastName.name,
        'MiddleName': MonthlyEnrollmentReporting.MiddleName.name,
        'FirstName': MonthlyEnrollmentReporting.FirstName.name,
        'Accredited': MonthlyEnrollmentReporting.Accredited.name,
        'Time': MonthlyEnrollmentReporting.TimeName.name,
        'Region': MonthlyEnrollmentReporting.RegionName.name,
        'AgeGroup': MonthlyEnrollmentReporting.AgeGroupName.name,
        'LicenseNumber': MonthlyEnrollmentReporting.SiteLicenseNumber.name,
        'TitleI': MonthlyEnrollmentReporting.TitleI.name,
        'Entry': MonthlyEnrollmentReporting.Entry.name,
        'Exit': MonthlyEnrollmentReporting.Exit.name,
        'Foster': MonthlyEnrollmentReporting.Foster.name,
        'Income': MonthlyEnrollmentReporting.Income.name,
        'AmericanIndianOrAlaskaNative': MonthlyEnrollmentReporting.AmericanIndianOrAlaskaNative.name,
        'Asian': MonthlyEnrollmentReporting.Asian.name,
        'BlackOrAfricanAmerican': MonthlyEnrollmentReporting.BlackOrAfricanAmerican.name,
        'NativeHawaiianOrPacificIslander': MonthlyEnrollmentReporting.NativeHawaiianOrPacificIslander.name,
        'White': MonthlyEnrollmentReporting.White.name,
        'HispanicOrLatinxEthnicity': MonthlyEnrollmentReporting.HispanicOrLatinxEthnicity.name,
        'Gender': MonthlyEnrollmentReporting.Gender.name,
        'Source': MonthlyEnrollmentReporting.FundingSource.name,
        'FacilityCode': MonthlyEnrollmentReporting.FacilityCode.name,
        'Zip': MonthlyEnrollmentReporting.ZipCode.name,
        'Town': MonthlyEnrollmentReporting.Town.name,
        'State': MonthlyEnrollmentReporting.State.name,
        'AddressLine': MonthlyEnrollmentReporting.CombinedAddress.name,
        'BirthCertificateId': MonthlyEnrollmentReporting.BirthCertificateId.name
    }
    enrollment_df = enrollment_df.rename(columns=rename_dict)

    # Remove non-existent columns
    table_cols = MonthlyEnrollmentReporting.__table__.columns.keys()
    enrollment_df = enrollment_df[list(set(enrollment_df.columns).intersection(table_cols))]

    return enrollment_df


def get_raw_spaces(report: pd.Series) -> pd.DataFrame:
    """
    Pull space metadata associated with the provided report
    :param report: pandas Series with report metadata
    :return: dataframe with information about spaces associated with report
    """

    parameters = {'report_id': report.Id}
    df = pd.read_sql(sql=text(open(SPACES_QUERY_FILE).read()), params=parameters, con=DATA_DB)
    return df


def transform_space_df(raw_space_df: pd.DataFrame, transformed_enrollment_df: pd.DataFrame) -> pd.DataFrame:

    # Rename time and age group for joining
    raw_space_df = replace_time_and_age_group_values(raw_space_df, 'Time', 'AgeGroup')

    # Merge space and enrollment df
    merged_df = raw_space_df.merge(transformed_enrollment_df, how='left',
                                   left_on=['OrganizationId', 'ReportingPeriodId', 'Time', 'AgeGroup'],
                                   right_on=['OrganizationId', 'ReportingPeriodId', 'TimeName', 'AgeGroupName'],
                                   suffixes=('', '_enrollment'))

    # Aggregate columns counting
    grouped_space_columns = merged_df.groupby(by=list(raw_space_df.columns)).agg(
        {'EnrollmentId': 'nunique', 'CDCRevenue': 'sum', 'TitleI': ['sum', lambda x:sum(x == 0)]}).reset_index()
    grouped_space_columns.columns = [''.join(col).strip() for col in grouped_space_columns.columns.values]
    rename_dict = {
        'TitleIsum': MonthlyOrganizationSpaceReporting.UtilizedTitleISpaces.name,
        'TitleI<lambda_0>': MonthlyOrganizationSpaceReporting.UtilizedNonTitle1Spaces.name,
        'EnrollmentIdnunique': MonthlyOrganizationSpaceReporting.UtilizedSpaces.name,
        'CDCRevenuesum': MonthlyOrganizationSpaceReporting.CDCRevenue.name,
        'ReportingPeriodId': MonthlyOrganizationSpaceReporting.ReportingPeriodId.name,
        'ReportId': MonthlyOrganizationSpaceReporting.ReportId.name,
        'Period': MonthlyOrganizationSpaceReporting.Period.name,
        'PeriodStart':MonthlyOrganizationSpaceReporting.ReportingPeriodStart.name,
        'PeriodEnd': MonthlyOrganizationSpaceReporting.ReportingPeriodEnd.name,
        'Accredited': MonthlyOrganizationSpaceReporting.Accredited.name,
        'Type': MonthlyOrganizationSpaceReporting.ReportFundingSourceType.name,
        'OrganizationId': MonthlyOrganizationSpaceReporting.OrganizationId.name,
        'OrganizationName': MonthlyOrganizationSpaceReporting.OrganizationName.name,
        'Capacity': MonthlyOrganizationSpaceReporting.Capacity.name,
        'Time': MonthlyOrganizationSpaceReporting.TimeName.name,
        'AgeGroup': MonthlyOrganizationSpaceReporting.AgeGroupName.name
    }

    grouped_space_columns.rename(columns=rename_dict, inplace=True)

    # Remove columns that don't exist in the database
    table_cols = MonthlyOrganizationSpaceReporting.__table__.columns.keys()
    space_df = grouped_space_columns[list(set(grouped_space_columns.columns).intersection(table_cols))]

    # Return dataframe ready to load
    return space_df


def get_raw_revenue(report: pd.Series) -> pd.DataFrame:
    """
    Placeholder function for passing metadata about revenue for a report
    :param report: Pandas series with metadata around a report
    :return: Datafrome containing information on single report
    """
    # Transform series into a dataframe and transpose it
    return report.to_frame().T


def transform_revenue_df(raw_revenue_df: pd.DataFrame, transformed_space_df: pd.DataFrame) -> pd.DataFrame:
    """
    Combine revenue data from the report items with space utilization from other queries
    :param raw_revenue_df: Report level revenue data and other metadata
    :param transformed_space_df: Space utilization and capacity dataframe
    :return: Combined dataframe with revenue sums and space metrics
    """
    # Combine dataframes and sum
    merged_df = raw_revenue_df.merge(transformed_space_df, how='left', left_on=['Id'], right_on=['ReportId'],
                                     suffixes=('', '_spaces'))
    grouped_columns = ['ReportingPeriodId', 'Id', 'Period', 'ReportingPeriodStart', 'ReportingPeriodEnd',
                       'Accredited_spaces', 'OrganizationId_spaces', 'OrganizationName', 'FamilyFeesRevenue',
                       'RetroactiveC4KRevenue', 'C4KRevenue']

    combined_value_df = merged_df.groupby(by=grouped_columns)[['CDCRevenue', 'Capacity', 'UtilizedSpaces']].sum().reset_index()

    # Rename columns
    rename_dict = {
        'ReportingPeriodId': MonthlyOrganizationRevenueReporting.ReportingPeriodId.name,
        'Id': MonthlyOrganizationRevenueReporting.ReportId.name,
        'Period': MonthlyOrganizationRevenueReporting.Period.name,
        'ReportingPeriodStart': MonthlyOrganizationRevenueReporting.ReportingPeriodStart.name,
        'ReportingPeriodEnd': MonthlyOrganizationRevenueReporting.ReportingPeriodEnd.name,
        'Accredited_spaces': MonthlyOrganizationRevenueReporting.Accredited.name,
        'OrganizationId_spaces': MonthlyOrganizationRevenueReporting.OrganizationId.name,
        'OrganizationName': MonthlyOrganizationRevenueReporting.OrganizationName.name,
        'FamilyFeesRevenue': MonthlyOrganizationRevenueReporting.FamilyFeesRevenue.name,
        'RetroactiveC4KRevenue': MonthlyOrganizationRevenueReporting.RetroactiveC4KRevenue.name,
        'C4KRevenue': MonthlyOrganizationRevenueReporting.C4KRevenue.name,
        'CDCRevenue': MonthlyOrganizationRevenueReporting.CDCRevenue.name,
        'Capacity': MonthlyOrganizationRevenueReporting.TotalCapacity.name,
        'UtilizedSpaces': MonthlyOrganizationRevenueReporting.UtilizedSpaces.name
    }
    combined_value_df = combined_value_df.rename(columns=rename_dict)

    # Drop columns that aren't in the table
    table_cols = MonthlyOrganizationRevenueReporting.__table__.columns.keys()
    combined_value_df = combined_value_df[list(set(combined_value_df.columns).intersection(table_cols))]
    return combined_value_df


def get_reports(start_date: datetime.timestamp, end_date: datetime.timestamp) -> pd.DataFrame:
    """
    Returns dataframe of reports that were submitted since the provided start time and before the provided end time
    :param start_date: First date of reports to pull, pulls all reports since midnight of given date
    :param end_date: Last day of reports by submission date, reports from this date will not be included
    :return: new_reports: Dataframe with each row with the metadata of the report to load
    """
    query = text("SELECT * FROM Report WHERE SubmittedAt >= :start_date and SubmittedAt < :end_date")
    new_reports = pd.read_sql(sql=query, params={'start_date': start_date, 'end_date': end_date}, con=DATA_DB)

    return new_reports






def replace_time_and_age_group_values(df: pd.DataFrame, time_col: str, age_group_col: str) -> pd.DataFrame:
    """
    Renames values in time and age group columns with names found in the custom rates file
    :param df: dataframe to transform
    :param time_col: time column name
    :param age_group_col: age group column name
    :return: dataframe with renamed values
    """
    rates_df = pd.read_csv(RATES_FILE)
    time_cols = rates_df[['TimeId', 'Time']]

    # Build time lookup from rates file
    time_dict = {}
    for i, row_dict in time_cols.drop_duplicates().set_index('TimeId').to_dict(orient='index').items():
        time_dict[i] = row_dict['Time']

    age_group_cols = rates_df[['AgeGroupId', 'AgeGroup']]

    # Build age group lookup from rates file
    age_group_dict = {}
    for i, row_dict in age_group_cols.drop_duplicates().set_index('AgeGroupId').to_dict(orient='index').items():
        age_group_dict[i] = row_dict['AgeGroup']

    df.replace({age_group_col: age_group_dict, time_col: time_dict}, inplace=True)
    return df
