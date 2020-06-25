import us
import os
import numpy as np
import pandas as pd
from datetime import datetime
import calendar
from analytic_tables.base_tables import MonthlyEnrollmentReporting
# An invalid state will return Null to the database
INVALID_STATE = None

SOURCE_DIR = os.path.dirname(__file__)
INCOME_LEVEL_FILE = SOURCE_DIR + '/data/IncomeLevels.csv'

ECE_REGION_MAPPING = {0: 'East',
                      1: 'North Central',
                      2: 'Northwest',
                      3: 'South Central',
                      4: 'Southwest'}

def get_beginning_and_end_of_month(date: datetime.date):
    """
    Get first and last day of a month
    :param date: date in a month to get the first and last date of
    :return: tuple of first and last day of a month
    """
    start = date.replace(day=1)
    end = date.replace(day=calendar.monthrange(date.year, date.month)[1])
    return start, end


def validate_and_convert_state(state_string: str) -> str:
    """
    Convert string to standard state abbreviation, returns None if there is no valid state in the string
    :param state_string: input string
    :return: Two letter state abbreviation or None
    """
    # Set Null as an empty string
    state_string = state_string if state_string else ''
    # Build dictionary keyed with potential names and with values as capitalized abbreviations
    # Seeded with ECIS data that includes birth certificates with an indicator of being an non-US birth certificate
    state_dict = {'not in usa': 'Not in USA'}
    for state_obj in us.STATES:
        base_abbr = state_obj.abbr

        # Load dictionary with lower case versions of names and abbreviations
        state_dict[base_abbr.lower()] = base_abbr
        state_dict[state_obj.name.lower()] = base_abbr

    # Match lower version of input with dictionary to get valid abbreviation,
    # returning None if it is not in the dictionary
    found_state = state_dict.get(state_string.lower(), INVALID_STATE)
    return found_state


def add_foster_logic(enrollment_df: pd.DataFrame, foster_col: str, income_col: str, family_size_col: str) -> pd.DataFrame:
    """
    Set Income to 0 and Family Size to 1 for Foster children
    :param enrollment_df: dataframe with enrollments with foster, income and family size columns
    :param foster_col: name of foster column in enrollment df
    :param income_col: name of column with income data
    :param family_size_col: name of column with family size
    :return: dataframe with updated family size and income column based on Foster
    """
    # Set family size to 1 for foster, leave as number of people for other
    family_size_col = np.where(enrollment_df[foster_col] == 1, 1, enrollment_df[family_size_col])
    enrollment_df[MonthlyEnrollmentReporting.FamilySize.name] = family_size_col

    # Overwrite income to 0 for foster children
    income_col = np.where(enrollment_df[foster_col] == 1, 0, enrollment_df[income_col])
    enrollment_df[MonthlyEnrollmentReporting.Income.name] = income_col
    return enrollment_df


def add_income_level(enrollment_df: pd.DataFrame, family_size_col: str, income_col: str) -> pd.DataFrame:
    """
    Adds booleans and income levels to a enrollment data frame based on a CSV
    :param enrollment_df: dataframe with enrollment data including columns for family size and income
    :param family_size_col: name of family size column
    :param income_col: name of income column
    :return: Input dataframe with State Median Income at 75%, and Federal Poverty Levels at 200% values and
    booleans
    """
    income_level_df = pd.read_csv(INCOME_LEVEL_FILE)
    income_level_df['NumberOfPeople'] = income_level_df['NumberOfPeople'].astype(object)
    enrollment_df = enrollment_df.merge(income_level_df,
                                        left_on=family_size_col,
                                        right_on='NumberOfPeople',
                                        how='left')
    enrollment_df[MonthlyEnrollmentReporting.SMI75.name] = enrollment_df['x75SMI']
    enrollment_df[MonthlyEnrollmentReporting.Under75SMI.name] = np.where(enrollment_df[income_col] < enrollment_df.x75SMI,
                                                                         1, 0)
    enrollment_df[MonthlyEnrollmentReporting.FPL200.name] = enrollment_df['x200FPL']
    enrollment_df[MonthlyEnrollmentReporting.Under200FPL.name] = np.where(enrollment_df[income_col] < enrollment_df.x200FPL,
                                                                          1, 0)

    return enrollment_df


def rename_and_drop_cols(df: pd.DataFrame, rename_dict: dict, table_cols: list) -> pd.DataFrame:
    """
    Rename columns in the given enrollment df and remove all columns that aren't in the Enrollment table
    :param df: dataframe
    :param rename_dict: Dictionary with mapping of input names to db column names
    :param table_cols: list of columns that should remain in the table
    :return: dataframe ready to load into Enrollment Table
    """
    renamed_df = df.rename(columns=rename_dict)
    reduced_renamed_df = renamed_df[list(set(renamed_df.columns).intersection(table_cols))]
    return reduced_renamed_df
