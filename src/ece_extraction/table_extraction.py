import os
import numpy as np
import pandas as pd
import sqlalchemy
from datetime import datetime, timedelta
from sqlalchemy.sql import text
from analytic_tables.constants import FULL_TIME, PART_TIME, INFANT_TODDLER, PRESCHOOL, SCHOOL_AGE, ECE_REPORTER
from resource_access.constants import ECE_DB_SECTION, PENSIEVE_DB_SECTION, ENROLLMENTS_FILE, SPACES_FILE, REVENUE_FILE, \
    S3_ECE_DATA_PATH
from resource_access.connections import get_mysql_connection, write_df_to_s3, get_s3_files_in_folder, get_s3_subfolders
from analytic_tables.conversion_functions import validate_and_convert_state, add_income_level, rename_and_drop_cols, \
    ECE_REGION_MAPPING, add_foster_logic, get_beginning_and_end_of_month
from analytic_tables.base_tables import MonthlyEnrollmentReporting, MonthlyOrganizationRevenueReporting, \
    MonthlyOrganizationSpaceReporting

ECE_DIR = os.path.dirname(__file__)
ENROLLMENT_QUERY_FILE = ECE_DIR + '/sql/functions/cdc_enrollment.sql'
SPACES_QUERY_FILE = ECE_DIR + '/sql/functions/cdc_spaces.sql'
REVENUE_QUERY_FILE = ECE_DIR + '/sql/functions/cdc_revenue.sql'

RATES_FILE = ECE_DIR + '/data/Rates.csv'

AGE_GROUP_MAPPING = {0: INFANT_TODDLER,
                     1: PRESCHOOL,
                     2: SCHOOL_AGE}

TIME_MAPPING = {0: FULL_TIME,
                1: PART_TIME}


def extract_ece_data(report: pd.Series, current_funding: bool = False) -> None:
    """
    Pulls ECE data on enrollments, spaces and reports and writes it to S3
    :param report: Report data from ECE Reporter
    :param current_funding: whether to use funding data as it exists in the database or data as it existed at report
    submission, historical is more accurate but will break for months before funding schema change
    :return: None, files uploaded to S3
    """
    print(f"Extracting report ID # {report.Id}")
    data_db = get_mysql_connection(ECE_DB_SECTION)
    file_prefix = 'submitted/' + str(datetime.strftime(report.SubmittedAt, '%Y-%m-01')) + '/' + str(report.Id)
    # Pull enrollments and write to S3
    raw_enrollments = get_raw_enrollments(report, current_funding=current_funding, db=data_db)
    enrollment_filename = file_prefix + '/' + ENROLLMENTS_FILE
    write_df_to_s3(df=raw_enrollments, filename=enrollment_filename)
    print("Uploaded enrollments")

    # Pull spaces and write to S3
    raw_space = get_raw_spaces(report, db=data_db)
    spaces_filename = file_prefix + '/' + SPACES_FILE
    write_df_to_s3(df=raw_space, filename=spaces_filename)
    print("Uploaded spaces")

    # Pull revenue and write to S3
    raw_revenue = get_raw_revenue(report, db=data_db)
    revenue_filename = file_prefix + '/' + REVENUE_FILE
    write_df_to_s3(df=raw_revenue, filename=revenue_filename)
    print("Uploaded revenue")


def transform_and_load_report(df_dict: dict,  pensieve_db: sqlalchemy.engine.Connection) -> None:
    """
    Converts raw pulls from ECE database, transforms them and loads to the DB
    :param df_dict: dictionary keyed with file names and values of dataframes
    :param pensieve_db: Connection to Pensieve database
    :return: None
    """
    raw_enrollment_df = df_dict[ENROLLMENTS_FILE]

    # Pull raw enrollment data and transform it
    transformed_enrollment_df = transform_enrollment_df(raw_enrollment_df)
    # Write enrollment to analytics DB
    transformed_enrollment_df.to_sql(name=MonthlyEnrollmentReporting.__tablename__,
                                     con=pensieve_db, if_exists='append', index=False, schema='pensieve')
    print("Enrollments loaded")

    # Pull raw space data, combine it with enrollments and transform it
    raw_space_df = df_dict[SPACES_FILE]
    transformed_space_df = transform_space_df(raw_space_df, transformed_enrollment_df)

    # Write space capacity and utilization to database
    transformed_space_df.to_sql(name=MonthlyOrganizationSpaceReporting.__tablename__,
                                con=pensieve_db, if_exists='append', index=False, schema='pensieve')
    print("Spaces loaded")

    # Pull raw revenue data, combine it with space data and transform
    raw_revenue_df = df_dict[REVENUE_FILE]
    transformed_revenue_df = transform_revenue_df(raw_revenue_df, transformed_space_df)

    # Write revenue data to database
    transformed_revenue_df.to_sql(name=MonthlyOrganizationRevenueReporting.__tablename__,
                                  con=pensieve_db, if_exists='append', index=False, schema='pensieve')
    print("Revenue loaded")


def process_ece_s3_data(submission_month: datetime.date) -> None:
    """
    Pulls all data associated with a report. Datasets pulled are enrollments, spaces and revenue. Data is transformed,
    cleaned and loaded to analytics tables
    :param submission_month
    :return: None, data is loaded to the DB
    """
    # Set up Pensieve for loading
    pensieve_db = get_mysql_connection(PENSIEVE_DB_SECTION)

    # Get report metadata to pull
    stage = os.environ['STAGE']
    start_of_month, _ = get_beginning_and_end_of_month(submission_month)

    # Get list of folders associated with each submitted report
    folder_prefix = f"pensieve/{stage}/{S3_ECE_DATA_PATH}/submitted/{start_of_month}"
    folder_list = get_s3_subfolders(folder_prefix)

    for folder in folder_list:
        print(f"Transforming and loading Report #{os.path.basename(folder)}")
        # Pull files from S3
        s3_df_dict = get_s3_files_in_folder(folder)
        transform_and_load_report(df_dict=s3_df_dict, pensieve_db=pensieve_db)


def get_raw_enrollments(report: pd.Series, db: sqlalchemy.engine.base.Connection,
                        current_funding: bool = False) -> pd.DataFrame:
    """
    Call cdc_enrollment.sql script with report metadata (SubmittedAt and Id) to get related Enrollments
    :param report: pandas series associated with a single report, Id and SubmittedAt are included
    :param current_funding: whether to use current funding data or historical data
    :param db: database connection object
    :return: dataframe with all enrollments associated with a report
    """
    funding_system_time = datetime.now() if current_funding else report.SubmittedAt
    parameters = {'system_time': report.SubmittedAt, 'report_id': report.Id, 'funding_system_time': funding_system_time}
    df = pd.read_sql(sql=text(open(ENROLLMENT_QUERY_FILE).read()), params=parameters, con=db)

    return df


def transform_enrollment_df(enrollment_df: pd.DataFrame) -> pd.DataFrame:

    # Add new columns
    if sum(enrollment_df['Source'] != 0) != 0:
        raise Exception("Non-CDC Source included in data pull")
    # Set all sources ID'd as 0 as CDC

    enrollment_df[MonthlyEnrollmentReporting.FundingSource.name] = MonthlyEnrollmentReporting.CDC_SOURCE
    enrollment_df[MonthlyEnrollmentReporting.SourceSystem.name] = ECE_REPORTER

    # Set period type
    enrollment_df[MonthlyEnrollmentReporting.PeriodType.name] = MonthlyEnrollmentReporting.MONTH

    # Add Income level booleans
    enrollment_df = add_income_level(enrollment_df,
                                     income_col='Income',
                                     family_size_col='NumberOfPeople')

    enrollment_df = add_foster_logic(enrollment_df=enrollment_df,
                                     family_size_col='NumberOfPeople',
                                     foster_col='Foster',
                                     income_col='Income')
    # Create a boolean column for children with two or more races
    race_cols = ['AmericanIndianOrAlaskaNative', 'Asian', 'BlackOrAfricanAmerican', 'NativeHawaiianOrPacificIslander', 'White']
    enrollment_df[MonthlyEnrollmentReporting.TwoOrMoreRaces.name] = np.where(enrollment_df[race_cols].sum(axis=1) > 1,
                                                                             1, 0)
    # Calculate monthly rate from number of weeks
    rates_df = pd.read_csv(RATES_FILE)

    date_cols = ['PeriodStart', 'PeriodEnd', 'StartDate', 'EndDate']
    for col in date_cols:
        enrollment_df[col] = pd.to_datetime(enrollment_df[col])
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

    # Standardize Gender
    enrollment_df['Gender'] = enrollment_df['Gender'].replace({0: MonthlyEnrollmentReporting.MALE,
                                                               1: MonthlyEnrollmentReporting.FEMALE})

    # Reformat birthdates
    enrollment_df[MonthlyEnrollmentReporting.BirthDate.name] = pd.to_datetime(enrollment_df['Birthdate'])

    # Rename regions
    enrollment_df[MonthlyEnrollmentReporting.RegionName.name] = enrollment_df['Region'].replace(ECE_REGION_MAPPING)
    # Rename columns
    rename_dict = {
        'ChildId': MonthlyEnrollmentReporting.SourceChildId.name,
        'OrganizationId': MonthlyEnrollmentReporting.SourceOrganizationId.name,
        'OrganizationName': MonthlyEnrollmentReporting.OrganizationName.name,
        'SiteId': MonthlyEnrollmentReporting.SourceSiteId.name,
        'SiteName': MonthlyEnrollmentReporting.SiteName.name,
        'EnrollmentId': MonthlyEnrollmentReporting.EnrollmentId.name,
        'FamilyDeterminationId': MonthlyEnrollmentReporting.FamilyDeterminationId.name,
        'FamilyId': MonthlyEnrollmentReporting.FamilyId.name,
        'ReportId': MonthlyEnrollmentReporting.ReportId.name,
        'Period': MonthlyEnrollmentReporting.Period.name,
        'PeriodStart': MonthlyEnrollmentReporting.PeriodStart.name,
        'PeriodEnd': MonthlyEnrollmentReporting.PeriodEnd.name,
        'Sasid': MonthlyEnrollmentReporting.Sasid.name,
        'LastName': MonthlyEnrollmentReporting.LastName.name,
        'MiddleName': MonthlyEnrollmentReporting.MiddleName.name,
        'FirstName': MonthlyEnrollmentReporting.FirstName.name,
        'Accredited': MonthlyEnrollmentReporting.Accredited.name,
        'Time': MonthlyEnrollmentReporting.CDCTimeName.name,
        'Region': MonthlyEnrollmentReporting.RegionName.name,
        'AgeGroup': MonthlyEnrollmentReporting.CDCAgeGroupName.name,
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

    enrollment_df = rename_and_drop_cols(df=enrollment_df, rename_dict=rename_dict,
                                         table_cols=MonthlyEnrollmentReporting.__table__.columns.keys())

    return enrollment_df


def get_raw_spaces(report: pd.Series, db: sqlalchemy.engine.base.Connection) -> pd.DataFrame:
    """
    Pull space metadata associated with the provided report
    :param report: pandas Series with report metadata
    :param db: Database connection object
    :return: dataframe with information about spaces associated with report
    """

    parameters = {'report_id': report.Id}
    df = pd.read_sql(sql=text(open(SPACES_QUERY_FILE).read()), params=parameters, con=db)
    return df


def transform_space_df(raw_space_df: pd.DataFrame, transformed_enrollment_df: pd.DataFrame) -> pd.DataFrame:

    # Rename time and age group for joining
    raw_space_df = replace_time_and_age_group_values(raw_space_df, 'Time', 'AgeGroup')

    # Add period type

    raw_space_df[MonthlyOrganizationSpaceReporting.PeriodType.name] = MonthlyOrganizationSpaceReporting.MONTH
    # Merge space and enrollment df
    merged_df = raw_space_df.merge(transformed_enrollment_df, how='left',
                                   left_on=['SourceOrganizationId', 'Period', 'PeriodType', 'Time', 'AgeGroup'],
                                   right_on=['SourceOrganizationId', 'Period', 'PeriodType', 'CDCTimeName', 'CDCAgeGroupName'],
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
        'ReportId': MonthlyOrganizationSpaceReporting.ReportId.name,
        'Period': MonthlyOrganizationSpaceReporting.Period.name,
        'PeriodType': MonthlyOrganizationSpaceReporting.PeriodType.name,
        'PeriodStart': MonthlyOrganizationSpaceReporting.PeriodStart.name,
        'PeriodEnd': MonthlyOrganizationSpaceReporting.PeriodEnd.name,
        'Accredited': MonthlyOrganizationSpaceReporting.Accredited.name,
        'Type': MonthlyOrganizationSpaceReporting.ReportFundingSourceType.name,
        'SourceOrganizationId': MonthlyOrganizationSpaceReporting.SourceOrganizationId.name,
        'OrganizationName': MonthlyOrganizationSpaceReporting.OrganizationName.name,
        'Capacity': MonthlyOrganizationSpaceReporting.Capacity.name,
        'Time': MonthlyOrganizationSpaceReporting.CDCTimeName.name,
        'AgeGroup': MonthlyOrganizationSpaceReporting.CDCAgeGroupName.name
    }

    # Rename columns and remove columns that don't exist in the database
    table_cols = MonthlyOrganizationSpaceReporting.__table__.columns.keys()
    space_df = rename_and_drop_cols(grouped_space_columns, table_cols=table_cols, rename_dict=rename_dict)

    return space_df


def get_raw_revenue(report: pd.Series, db: sqlalchemy.engine.base.Connection) -> pd.DataFrame:
    """
    Placeholder function for passing metadata about revenue for a report
    :param report: Pandas series with metadata around a report
    :param db: database connection for ECE database
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
    grouped_columns = ['ReportingPeriodId', 'Id', 'Period', 'PeriodStart', 'PeriodEnd',
                       'Accredited_spaces', 'SourceOrganizationId', 'OrganizationName', 'FamilyFeesRevenue',
                       'RetroactiveC4KRevenue', 'C4KRevenue']

    combined_value_df = merged_df.groupby(by=grouped_columns)[['CDCRevenue', 'Capacity', 'UtilizedSpaces']].sum().reset_index()

    # Add source and month
    combined_value_df[MonthlyOrganizationRevenueReporting.ReportFundingSourceType.name] = MonthlyOrganizationRevenueReporting.CDC_SOURCE
    combined_value_df[MonthlyOrganizationRevenueReporting.PeriodType.name] = MonthlyOrganizationRevenueReporting.MONTH
    # Rename columns
    rename_dict = {
        'Id': MonthlyOrganizationRevenueReporting.ReportId.name,
        'Period': MonthlyOrganizationRevenueReporting.Period.name,
        'PeriodStart': MonthlyOrganizationRevenueReporting.PeriodStart.name,
        'PeriodEnd': MonthlyOrganizationRevenueReporting.PeriodEnd.name,
        'Accredited_spaces': MonthlyOrganizationRevenueReporting.Accredited.name,
        'SourceOrganizationId': MonthlyOrganizationRevenueReporting.SourceOrganizationId.name,
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


def get_reports(start_date: datetime.timestamp, end_date: datetime.timestamp, db: sqlalchemy.engine.base.Connection) -> pd.DataFrame:
    """
    Returns dataframe of reports that were submitted since the provided start time and before the provided end time
    :param start_date: First date of reports to pull, pulls all reports since midnight of given date
    :param end_date: Last day of reports by submission date, reports from this date will not be included
    :param db: database connection for ECE database
    :return: new_reports: Dataframe with each row with the metadata of the report to load
    """
    query = text("SELECT Report.*, RP.Period "
                 "FROM Report "
                 "INNER JOIN ReportingPeriod RP on Report.ReportingPeriodId = RP.Id "
                 "WHERE SubmittedAt >= :start_date and SubmittedAt < :end_date")
    new_reports = pd.read_sql(sql=query, params={'start_date': start_date, 'end_date': end_date}, con=db)

    return new_reports


def get_month_of_reports(month: datetime.date) -> pd.DataFrame:
    """
    Pull all reports that were submitted in the provided month
    :param month: date within the month to be pulled
    :return: dataframe with metadata about reports submitted in a month
    """

    # Get the first and last day of last month
    month_start, month_end = get_beginning_and_end_of_month(month)
    data_db = get_mysql_connection(ECE_DB_SECTION)

    # Get all reports submitted last month and write results to S3
    report_df = get_reports(start_date=month_start, end_date=month_end + timedelta(days=1), db=data_db)
    return report_df


def replace_time_and_age_group_values(df: pd.DataFrame, time_col: str, age_group_col: str) -> pd.DataFrame:
    """
    Renames values in time and age group columns with names found in the custom rates file and adds a general space
    type column
    :param df: dataframe to transform
    :param time_col: time column name
    :param age_group_col: age group column name
    :return: dataframe with renamed values
    """
    # Data mapping enum from ECE Reporter
    df = df.replace({age_group_col: AGE_GROUP_MAPPING, time_col: TIME_MAPPING})
    df[MonthlyEnrollmentReporting.SpaceType.name] = df[age_group_col] + '-' + df[time_col]
    return df
