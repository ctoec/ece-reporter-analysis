import os
import numpy as np
import pandas as pd
from datetime import datetime
from sqlalchemy.sql import text
from analytic_tables import constants
from resource_access.constants import ECIS_DB_SECTION, PENSIEVE_DB_SECTION
from resource_access.connections import get_mysql_connection
from analytic_tables.conversion_functions import get_beginning_and_end_of_month, validate_and_convert_state, \
    add_income_level, add_foster_logic, rename_and_drop_cols, ECE_REGION_MAPPING
from analytic_tables.base_tables import MonthlyOrganizationRevenueReporting, MonthlyEnrollmentReporting, \
    MonthlyOrganizationSpaceReporting

ECIS_DB = get_mysql_connection(ECIS_DB_SECTION)
PENSIEVE_DB = get_mysql_connection(PENSIEVE_DB_SECTION)

# Get default files
ECIS_DIR = os.path.dirname(__file__)
ENROLLMENT_QUERY_FILE = ECIS_DIR + '/sql/functions/ecis_enrollment_extraction.sql'
TOWN_REGION_LOOKUP = ECIS_DIR + '/data/towns.csv'

# ECIS Age Groups
ECIS_PRE_SCHOOL = 'PS'
ECIS_INFANT_TODDLER = 'IT'
DUMMY_NULL = 'NULL VALUE'

# ECIS times
ECIS_FULL_TIME = 'F/T'
ECIS_WRAP_AROUND = 'WA'
ECIS_SCHOOL_AGE = 'School Age'

RACE_ETHNICITY_LIST = [('Hispanic or Latino of any race', MonthlyEnrollmentReporting.HispanicOrLatinxEthnicity.name),
                       ('Black or African American', MonthlyEnrollmentReporting.BlackOrAfricanAmerican.name),
                       ('American Indian or Alaska Native', MonthlyEnrollmentReporting.AmericanIndianOrAlaskaNative.name),
                       ('White', MonthlyEnrollmentReporting.White.name),
                       ('Native Hawaiian or Other Pacific Islander', MonthlyEnrollmentReporting.NativeHawaiianOrPacificIslander.name),
                       ('Asian', MonthlyEnrollmentReporting.Asian.name)
                       ]

ECIS_CHILD_DAY_CARE = 'Child Day Care'
FUNDING_MAPPING = {ECIS_CHILD_DAY_CARE: MonthlyEnrollmentReporting.CDC_SOURCE,
                   'Head Start – State Supplement': MonthlyEnrollmentReporting.STATE_HEAD_START,
                   'Smart Start (SS)': MonthlyEnrollmentReporting.SMART_START,
                   'Head Start/Early Head Start': MonthlyEnrollmentReporting.HEAD_START,
                   'PDG-Federal': MonthlyEnrollmentReporting.PDG_FEDERAL,
                   'School Readiness – Priority': MonthlyEnrollmentReporting.SCHOOL_READINESS_PRIORITY,
                   'PDG-State Quality Enhancement': MonthlyEnrollmentReporting.PDG_STATE,
                   'Private Pay': MonthlyEnrollmentReporting.PRIVATE_PAY,
                   'School Readiness – Competitive': MonthlyEnrollmentReporting.SCHOOL_READINESS_COMPETITIVE
                   }


def load_month_of_reports(month: datetime.date) -> None:
    """
    Pull enrollments for a month, transform them and load the resulting dataframe to the database
    :param month: Month for which data will be pulled and loaded
    :return: None
    """
    start_date, end_date = get_beginning_and_end_of_month(month)
    enrollment_df = get_raw_enrollment_df(start_date=start_date, end_date=end_date)
    print(f"Data Extracted from ECIS for month: {start_date} at {datetime.now()}")
    transformed_enrollment_df = transform_enrollment_df(enrollment_df, start_date, end_date)
    print(f"Enrollment data transformed")
    transformed_enrollment_df.to_sql(name=MonthlyEnrollmentReporting.__tablename__,
                                     con=PENSIEVE_DB, if_exists='append', index=False, schema='pensieve')
    print(f"Enrollment data loaded to database for month: {start_date} at {datetime.now()}")
    # Transform enrollment dataframe into space dataframe
    space_and_utilization_df = create_space_df(transformed_enrollment_df)
    print(f"Space dataframe created")
    space_and_utilization_df.to_sql(name=MonthlyOrganizationSpaceReporting.__tablename__,
                                    con=PENSIEVE_DB, if_exists='append', index=False, schema='pensieve')
    print("Space data loaded")
    # Create organization level dataframe from space level dataframe
    organization_df = create_organization_df(space_and_utilization_df)
    print("Organization data created")
    organization_df.to_sql(name=MonthlyOrganizationRevenueReporting.__tablename__,
                           con=PENSIEVE_DB, if_exists='append', index=False, schema='pensieve')
    print("Organization data loaded")


def get_raw_enrollment_df(start_date: datetime.date, end_date: datetime.date) -> pd.DataFrame:
    """
    Pulls all records in ECIS that were active during the month of the date that is passed
    :param start_date:
    :param end_date:
    :return: dataframe of enrollments for the given month
    """
    parameters = {'start_date': start_date, 'end_date': end_date}
    df = pd.read_sql(sql=text(open(ENROLLMENT_QUERY_FILE).read()), params=parameters, con=ECIS_DB)
    return df


def transform_enrollment_df(enrollment_df: pd.DataFrame, month_start: datetime.date, month_end: datetime.date) -> pd.DataFrame:
    """
    Transforms enrollment data from SQL pull to rename and standardize columns for loading into shared analytics table
    :param enrollment_df:
    :param month_start:
    :param month_end:
    :return: dataframe ready to load to analytics DB
    """
    enrollment_df[MonthlyEnrollmentReporting.Period.name] = month_start
    enrollment_df[MonthlyEnrollmentReporting.PeriodType.name] = MonthlyEnrollmentReporting.MONTH
    enrollment_df[MonthlyEnrollmentReporting.PeriodStart.name] = month_start
    enrollment_df[MonthlyEnrollmentReporting.PeriodEnd.name] = month_end
    enrollment_df[MonthlyEnrollmentReporting.SourceSystem.name] = constants.HISTORICAL_ECIS

    # Convert for foster families
    foster_col = np.where(enrollment_df['AddressType'] == 'Foster Parent', 1, 0)
    enrollment_df[MonthlyEnrollmentReporting.Foster.name] = foster_col

    # Add family size and income with adjusted logic for Foster
    enrollment_df = add_foster_logic(enrollment_df=enrollment_df,
                                     income_col='AnnualFamilyIncome',
                                     foster_col=MonthlyEnrollmentReporting.Foster.name,
                                     family_size_col='NumberOfPeopleInHousehold')

    # Create race and ethnicity columns
    for string, col_name in RACE_ETHNICITY_LIST:
        enrollment_df[col_name] = enrollment_df['RaceList'].str.contains(string)

    # Add column for two or more races
    race_cols = [x[1] for x in RACE_ETHNICITY_LIST if 'Hispanic' not in x[0]]
    enrollment_df[MonthlyEnrollmentReporting.TwoOrMoreRaces.name] = np.where(enrollment_df[race_cols].sum(axis=1) > 1,
                                                                             1, 0)
    # Validate states
    enrollment_df['State'] = enrollment_df['State'].apply(validate_and_convert_state)
    enrollment_df['StateOfBirth'] = enrollment_df['StateOfBirth'].apply(validate_and_convert_state)

    # Use common values for gender
    enrollment_df[MonthlyEnrollmentReporting.Gender.name] = enrollment_df['Gender'].replace({'M ': MonthlyEnrollmentReporting.MALE,
                                                                                             'F ': MonthlyEnrollmentReporting.FEMALE})

    # Convert birthdates
    enrollment_df[MonthlyEnrollmentReporting.BirthDate.name] = pd.to_datetime(enrollment_df['Dob'], errors='coerce')

    # Switch to canonical funding sources
    renamed_funding_cols = enrollment_df['FundingType'].replace(FUNDING_MAPPING)
    enrollment_df[MonthlyEnrollmentReporting.FundingSource.name] = renamed_funding_cols

    # Add booleans and relative income levels based on family size
    enrollment_df = add_income_level(enrollment_df,
                                     income_col=MonthlyEnrollmentReporting.Income.name,
                                     family_size_col=MonthlyEnrollmentReporting.FamilySize.name)

    # Add flag for whether C4K is included in additional funding
    enrollment_df[MonthlyEnrollmentReporting.ActiveC4K.name] = np.where(enrollment_df.AdditionalFundingTypes.str.contains('Care 4 Kids'), 1, 0)

    # Add Region based on Town name
    enrollment_df[MonthlyEnrollmentReporting.RegionName.name] = enrollment_df['Town'].apply(get_region)

    # Add Time and Age Group for CDC Funding
    cdc_rows = enrollment_df.FundingSource == MonthlyEnrollmentReporting.CDC_SOURCE
    enrollment_df[MonthlyEnrollmentReporting.SpaceType.name] = enrollment_df['SpaceType']
    enrollment_df.loc[cdc_rows, MonthlyEnrollmentReporting.CDCTimeName.name] = enrollment_df.loc[
        cdc_rows]['SpaceType'].apply(extract_time_from_ECIS)
    enrollment_df.loc[cdc_rows, MonthlyEnrollmentReporting.CDCAgeGroupName.name] = enrollment_df.loc[
        cdc_rows]['SpaceType'].apply(extract_age_group_from_ECIS)
    enrollment_df.loc[cdc_rows, MonthlyEnrollmentReporting.SpaceType.name] = enrollment_df[MonthlyEnrollmentReporting.CDCAgeGroupName.name] + \
                                                                             '-' + enrollment_df[MonthlyEnrollmentReporting.CDCTimeName.name]

    # Rename columns
    rename_dict = {'StudentId': MonthlyEnrollmentReporting.SourceChildId.name,
                   'OrganizationId': MonthlyEnrollmentReporting.SourceOrganizationId.name,
                   'FacilityId': MonthlyEnrollmentReporting.SourceSiteId.name,
                   'Name': MonthlyEnrollmentReporting.SiteName.name,
                   'Code': MonthlyEnrollmentReporting.FacilityCode.name,
                   'EnrollmentId': MonthlyEnrollmentReporting.EnrollmentId.name,
                   'SASID': MonthlyEnrollmentReporting.Sasid.name,
                   'BirthCertificateId': MonthlyEnrollmentReporting.BirthCertificateId.name,
                   'State': MonthlyEnrollmentReporting.State.name,
                   'StateOfBirth': MonthlyEnrollmentReporting.StateOfBirth.name,
                   'TownOfBirth': MonthlyEnrollmentReporting.TownOfBirth,
                   'LastName': MonthlyEnrollmentReporting.LastName.name,
                   'MiddleName': MonthlyEnrollmentReporting.MiddleName.name,
                   'FirstName': MonthlyEnrollmentReporting.FirstName.name,
                   'Town': MonthlyEnrollmentReporting.Town.name,
                   'Zip': MonthlyEnrollmentReporting.ZipCode.name,
                   'Address': MonthlyEnrollmentReporting.CombinedAddress.name,
                   'Gender': MonthlyEnrollmentReporting.Gender.name,
                   'IndividualizedIEP': MonthlyEnrollmentReporting.HasIEP.name,
                   'EnrollmentDate': MonthlyEnrollmentReporting.Entry.name,
                   'FacilityExitDate': MonthlyEnrollmentReporting.Exit.name
                   }
    table_cols = MonthlyEnrollmentReporting.__table__.columns.keys()
    enrollment_df = rename_and_drop_cols(df=enrollment_df, rename_dict=rename_dict, table_cols=table_cols)

    # Drop row that has duplicate values due to a malformed DOB
    bad_row = enrollment_df[(enrollment_df['SourceChildId'] == 6798) & (pd.isnull(enrollment_df['BirthDate']))]
    if len(bad_row) > 0:
        enrollment_df = enrollment_df.drop(bad_row.index[0])
    return enrollment_df


def create_space_df(transformed_enrollment_df: pd.DataFrame) -> pd.DataFrame:
    """
    Groups enrollment dataframe to load spaces and utilization on the organization and source type level
    :param transformed_enrollment_df:
    :return: space_df with rows for each funding type
    """
    # Group by primary keys and descriptive names
    ## TODO
    # Add organization name
    key_cols = [MonthlyEnrollmentReporting.Period.name, MonthlyEnrollmentReporting.PeriodType.name,
                MonthlyEnrollmentReporting.PeriodStart.name, MonthlyEnrollmentReporting.PeriodEnd.name,
                MonthlyEnrollmentReporting.FundingSource.name, MonthlyEnrollmentReporting.SourceOrganizationId.name,
                MonthlyEnrollmentReporting.CDCTimeName.name, MonthlyEnrollmentReporting.CDCAgeGroupName.name,
                MonthlyEnrollmentReporting.SpaceType.name]

    # Replace NULLs with text so they are included in grouping
    ## TODO
    # Pandas 1.1 will allow for including NULLs
    transformed_enrollment_df[key_cols] = transformed_enrollment_df[key_cols].fillna(DUMMY_NULL)
    grouped_df = transformed_enrollment_df.groupby(key_cols).size().reset_index()

    # Change null string back to actual NULLs
    grouped_df.replace({DUMMY_NULL: None}, inplace=True)

    # Rename columns
    rename_dict = {MonthlyEnrollmentReporting.Period.name: MonthlyOrganizationSpaceReporting.Period.name,
                   MonthlyEnrollmentReporting.PeriodType.name: MonthlyOrganizationSpaceReporting.PeriodType.name,
                   MonthlyEnrollmentReporting.FundingSource.name: MonthlyOrganizationSpaceReporting.ReportFundingSourceType.name,
                   MonthlyEnrollmentReporting.PeriodEnd.name: MonthlyOrganizationSpaceReporting.PeriodEnd.name,
                   MonthlyEnrollmentReporting.PeriodStart.name: MonthlyOrganizationSpaceReporting.PeriodStart.name,
                   MonthlyEnrollmentReporting.SourceOrganizationId.name: MonthlyOrganizationSpaceReporting.SourceOrganizationId.name,
                   MonthlyEnrollmentReporting.CDCTimeName.name: MonthlyOrganizationSpaceReporting.CDCTimeName.name,
                   MonthlyEnrollmentReporting.CDCAgeGroupName.name: MonthlyOrganizationSpaceReporting.CDCAgeGroupName.name,
                   MonthlyEnrollmentReporting.SpaceType.name: MonthlyOrganizationSpaceReporting.SpaceType.name,
                   0: MonthlyOrganizationSpaceReporting.UtilizedSpaces.name}
    table_cols = MonthlyOrganizationSpaceReporting.__table__.columns.keys()
    renamed_grouped_df = rename_and_drop_cols(grouped_df, rename_dict=rename_dict, table_cols=table_cols)

    return renamed_grouped_df


def create_organization_df(space_df: pd.DataFrame) -> pd.DataFrame:
    """
    Convert space dataframe to sum up to the organization level
    :param space_df:
    :return: organization df
    """
    grouping_cols = [MonthlyOrganizationSpaceReporting.Period.name, MonthlyOrganizationSpaceReporting.PeriodType.name,
                     MonthlyOrganizationSpaceReporting.PeriodStart.name, MonthlyOrganizationSpaceReporting.PeriodEnd.name,
                     MonthlyOrganizationSpaceReporting.SourceOrganizationId.name,
                     MonthlyOrganizationSpaceReporting.ReportFundingSourceType.name]

    space_df[grouping_cols] = space_df[grouping_cols].fillna(DUMMY_NULL)
    grouped_df = space_df.groupby(grouping_cols)[MonthlyOrganizationSpaceReporting.UtilizedSpaces.name].sum().reset_index()
    grouped_df.replace({DUMMY_NULL: None}, inplace=True)

    table_cols = MonthlyOrganizationRevenueReporting.__table__.columns.keys()
    rename_dict = {
        MonthlyOrganizationSpaceReporting.Period.name: MonthlyOrganizationRevenueReporting.Period.name,
        MonthlyOrganizationSpaceReporting.PeriodType.name: MonthlyOrganizationRevenueReporting.PeriodType.name,
        MonthlyOrganizationSpaceReporting.PeriodStart.name: MonthlyOrganizationRevenueReporting.PeriodStart.name,
        MonthlyOrganizationSpaceReporting.PeriodEnd.name: MonthlyOrganizationRevenueReporting.PeriodEnd.name,
        MonthlyOrganizationSpaceReporting.SourceOrganizationId.name: MonthlyOrganizationRevenueReporting.SourceOrganizationId.name,
        MonthlyOrganizationSpaceReporting.ReportFundingSourceType.name: MonthlyOrganizationRevenueReporting.ReportFundingSourceType.name,
        MonthlyOrganizationSpaceReporting.UtilizedSpaces.name: MonthlyOrganizationRevenueReporting.UtilizedSpaces.name
    }

    renamed_grouped_df = rename_and_drop_cols(grouped_df, rename_dict=rename_dict, table_cols=table_cols)
    return renamed_grouped_df


def get_region(town_name: str) -> str:
    """
    Get the region associated with a town from custom file
    :param town_name: Name of town to look up
    :return: region_name
    """
    town_name = town_name if town_name else ''
    df = pd.read_csv(TOWN_REGION_LOOKUP)
    df['town'] = df['town'].str.lower()
    town_lookup = df.set_index('town').to_dict()['region']
    region_id = town_lookup.get(town_name.lower(), None)
    region_name = ECE_REGION_MAPPING.get(region_id, None)
    return region_name


def extract_time_from_ECIS(space_type: str) -> str:
    """
    Look up canonical time from ECIS data
    :param space_type: string from ECIS
    :return:
    """
    space_type = space_type.strip()
    if constants.ECIS_FULL_TIME in space_type:
        return constants.FULL_TIME
    if constants.ECIS_WRAP_AROUND in space_type:
        return constants.PART_TIME
    if space_type == constants.ECIS_SCHOOL_AGE:
        return constants.PART_TIME
    raise Exception(f"{space_type} does not have a valid time")


def extract_age_group_from_ECIS(space_type: str) -> str:
    """
    Get canonical age group from space type in ECIS
    :param space_type: space type from ECIS
    :return: canonical age group name
    """
    if ECIS_INFANT_TODDLER in space_type:
        return constants.INFANT_TODDLER
    if ECIS_PRE_SCHOOL in space_type:
        return constants.PRESCHOOL
    if constants.ECIS_SCHOOL_AGE in space_type:
        return constants.SCHOOL_AGE
    # If none of the items are found raise an error
    raise Exception(f"Space type {space_type} does not have a valid time.")
