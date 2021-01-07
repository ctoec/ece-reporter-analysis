ECIS_SUMMER_2020 = 'data/ecis_july_data.csv'
# This file is a tab separated cut and paste from the password protected file provided by Julie Bisi
ALL_SITE_FILE = 'data/all_sites.csv'

RACE_COLS = ['Race: American Indian or Alaska Native',
             'Race: Asian',
             'Race: Black or African American',
             'Race: Native Hawaiian or Pacific Islander',
             'Race: white']

ECE_COLUMNS = ['First name',
               'Middle name',
               'Last name',
               'Suffix',
               'SASID / unique identifier',
               'Date of birth',
               'Birth certificate type',
               'Birth certificate ID #',
               'Town of birth',
               'State of birth'] + RACE_COLS + [
               'Race not disclosed',
               'Hispanic or Latinx ethnicity',
               'Gender',
               'Dual language learner',
               'Receiving disability and/or special education services',
               'Street address',
               'Town',
               'State',
               'Zipcode',
               'Lives with foster family',
               'Experiencing homelessness or housing insecurity',
               'Household size',
               'Annual household income',
               'Determination date',
               'Provider',
               'Site',
               'Care model',
               'Age group',
               'Enrollment start date',
               'Enrollment end date',
               'Enrollment exit reason',
               'Funding type',
               'Space type',
               'First funding period',
               'Last funding period'] 

COLUMN_MAPPING_ECIS_ECE = {
    'FirstName': 'First name',
    'MiddleName': 'Middle name',
    'LastName': 'Last name',
    'Suffix': 'Suffix',
    'SASID': 'SASID / unique identifier',
    'DateOfBirth': 'Date of birth',
    'BirthCertificateId': 'Birth certificate ID #',
    'TownOfBirth': 'Town of birth',
    'StateOfBirth': 'State of birth',
    'AmericanIndianOrAlaskaNative': 'Race: American Indian or Alaska Native',
    'Asian': 'Race: Asian',
    'BlackOrAfricanAmerican': 'Race: Black or African American',
    'NativeHawaiianOrOtherPacificIslander': 'Race: Native Hawaiian or Pacific Islander',
    'White': 'Race: white',
    'Ethnicity': 'Hispanic or Latinx ethnicity',
    'Gender': 'Gender',
    'IEP': 'Receiving disability and/or special education services',
    'Town': 'Town',
    'State': 'State',
    'ZipCode': 'Zipcode',
    'NumberOfPeopleInHousehold': 'Household size',
    'AnnualFamilyIncome': 'Annual household income',
    'DateFamilyIncomeDocumented': 'Determination date',
    # '': 'Provider',
    # '': 'Site',
    # '': 'Age group',
    'FacilityEntryDate': 'Enrollment start date',
    'FacilityExitDate': 'Enrollment end date',
    'ExitCategory': 'Enrollment exit reason',
    'FundingType': 'Funding type',
    'SpaceTypeCode': 'Space type',
    'FundingStartDate': 'First funding period',
    'FundingEndDate': 'Last funding period'
}

CDC_NAME = 'CDC - Child Day Care'
CSR_NAME = 'CSR - Competitive School Readiness'
PSR_NAME = 'PSR - Priority School Readiness'
SHS_NAME = 'SHS - State Head Start'
SS_NAME = 'SS - Smart Start'

FUNDING_TYPE = {'Child Day Care': CDC_NAME,
                'School Readiness – Competitive': CSR_NAME,
                'School Readiness – Priority': PSR_NAME,
                'Head Start – State Supplement': SHS_NAME,
                'Smart Start (SS)': SS_NAME}

EXIT_REASONS = {'Aged Out':'Aged out',
                'Child Stopped Attending':'Stopped attending',
                'Chose to Attend A Different Program':'Chose to attend a different program',
                'Moved to Another Town':'Moved within Connecticut',
                'Moved to Another State':'Moved to another state',
                'Child Was Asked To Leave':'Child was asked to leave',
                'Other':'Unknown',
                'Parent Withdrew Child':'Stopped attending',
                'Unknown':'Unknown'}


INFANT_TODDLER_ECIS = 'Infant/Toddler'
PRESCHOOL_ECIS = 'Preschool'

PRESCHOOL_ECE = 'Preschool'
INFANT_TODDLER_ECE = 'Infant/toddler'
SCHOOL_AGED_ECE = 'School aged '


def get_age_group(funding_and_space_type: str) -> str:
    """
    Parses funding type and space type from ECIS extraction to convert to age group in ECE format
    :param funding_and_space_type: ECIS funding type + '||' + space type
    :return: Age group
    """
    split_list = funding_and_space_type.split('||')
    funding_type = split_list[0].strip()
    space_type = split_list[1].strip()
    pre_school_funding_types = [PSR_NAME, CSR_NAME, SHS_NAME, SS_NAME]
    if funding_type in pre_school_funding_types:
        return PRESCHOOL_ECE
    if INFANT_TODDLER_ECIS in space_type:
        return INFANT_TODDLER_ECE
    if PRESCHOOL_ECIS in space_type:
        return PRESCHOOL_ECE

    raise Exception(f"funding type {funding_type}, Space type {space_type} does not have an age group")


# Using data from https://ece-reporter.ctoec.org/funding-space-types assuming keys of funding type and space type
SPACE_TYPE_LOOKUP = {'PSR - Priority School Readiness || Full Day/Full Year (FD/FY)': 4,
                     'CSR - Competitive School Readiness || Full Day/Full Year (FD/FY)': 4,
                     'CSR - Competitive School Readiness || School Day/School Year (SD/SY)': 5,
                     'CSR - Competitive School Readiness || Part Day/Part Year (PD/PY)': 6,
                     'PSR - Priority School Readiness || School Day/School Year (SD/SY)': 5,
                     'CDC - Child Day Care || Preschool Full-Time (PS F/T)': 1,
                     'CDC - Child Day Care || Infant/Toddler Full-Time (IT F/T)': 1,
                     'PSR - Priority School Readiness || Part Day/Part Year (PD/PY)': 6,
                     'SHS - State Head Start || Extended Day': 14,
                     'PSR - Priority School Readiness || Extended Day (ED)': 7,
                     'SHS - State Head Start || State Enrollment': 9,
                     'CDC - Child Day Care || Infant/Toddler Wrap Around (IT WA)': 2,
                     'CDC - Child Day Care || Preschool Wrap Around (PS WA)': 2,
                     'SS - Smart Start || School Day/School Year (SD/SY)': 8,
                     'SHS - State Head Start || Extended Year': 13}




