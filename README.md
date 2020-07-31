# oec-data-tools

This repository contains code to support collecting data from ECE Reporter and other sources and ingesting
it into a centralized analytics database.

## src

### analytic_tables

SQLAlchemy code that creates and represents base analytics tables. There are no migrations
as of 2020-06-02 but when they become necessary they will be run by [Alembic](https://pypi.org/project/alembic/). 

### resource_access

Centralized code with connections to data sources, called by extraction scripts

### ece_extraction

This code pulls data from ECE Reporter in an ordered manner than can be used in a potential future
ingestion framework. It breaks down the ingestion process into various extraction, transformation
and combination steps. 

The order of operations is divided into two components, extraction from ECE Reporter, then transforming and loading to Pensieve.

Both runs require a config.ini file in `src/resource_access` and can either locally or on ECE server. Setting the host as 
`host.docker.internal` will allow the container to access open ports on the host machine. The config file for ECE Extraction
only requires the ECE Reporter DB to be filled out. If running locally configure the host and ports to be set up with 
local ports that have been tunnelled and forwarded to the appropriate ports on production.

The docker-compose for both processes looks in the home directory of the running machine under .aws (`~/.aws`) for a config file to 
access S3, this folder is created when the AWS CLI is configured.

#### extraction
Running `STAGE={stage} docker-compose -f docker-compose-ece.yml up --build`
with the appropriate stage filled in will extract data submitted in the prior month from ECE and upload the results
to S3. 

1. Extract Enrollment data
1. Load Enrollment data to S3
1. Extract Capacity data
1. Load Capacity data to S3
1. Extract Report Revenue data
1. Load Revenue data to S3

#### Transformation and loading

This process needs to be run with local port access to the Pensieve database and the S3 bucket where extracted data was placed.
Running `STAGE=prod docker-compose -f docker-compose-ece-load.yml up --build` will pull the data from S3 that was submitted last month, 
run transformations on it and load the Pensieve DB. The config file here only requires the Pensieve DB setup.

1. Transform Enrollment data
   - Rename columns
   - Add booleans for income levels relative the state median income (SMI) and federal poverty level (FPL)
   - Check active C4K certificate
   - Add logic setting income to 0 and family size to 1 for foster children
   - Create boolean for children of more than one race
   - Calculate monthly rate
1. Load Enrollment data

1. Combine Capacity data with Enrollment data to calculate Utilized Spaces
1. Load Capacity/Utilization data to DB

1. Combine Report and Capacity/Utilization data to get overall revenue numbers
1. Load Revenue data to DB.


#### sql

SQL code used to extract key views from different tables in the ECE Reporter database. The resulting
dataframes are combined and transformed in the code in `src/ece_extraction/table_extraction.py`.

#### data
Static tables used in transforming data, this will need to updated as they change. Updates should be yearly.
- IncomeLevels: Income levels by family size for 75% of State Median Income and 200% of Federal Poverty Level.
- Rates: Pre-set rates for Child Day Care slots based on various child and site characteristics. 

#### TODOs

- Add Funding Time Splits, current reporting only allows for FT or PT

### ecis_extraction

This pulls data from the ECIS system and inserts it in the analytical database with enrollments
on a monthly basis historically. As of 2020-06-25 the data is from a snapshot of the ECIS database
as of Feb. 2020.

The steps of the ETL process are:
1. Extract data from all programs (CDC, School Readiness, etc.) from ECIS 
1. Transform Enrollment & Funding data
    - Add period names including starts and ends
    - Set Foster based on address type and update income to 0 and family size to 1 per OEC definitions
    - Extract race and ethnicity data, adding a boolean for students with two or more races
    - Validate and standardize state names
    - Standardize gender to text (M,F currently)
    - Extract birthdate
    - Standardize funding sources
    - Set up flag for C4K, note that there is no indication in the ECIS data on when C4K is active
    - Set Region based on csv in data folder
    - Extract Time and Age Group for CDC Funding
1. Load transformed data to Monthly Enrollment table
1. Group Enrollment/Funding data by Funding Type along with Time and Age Group for CDC to get counts for each type
1. Rename columns of dataframe and load to Monthly Spaces, only Utilization numbers will be added, Capacity is not included since ECIS doesn't track it. 
1. Load Monthly Spaces to DB
1. Transform Monthly Spaces dataframe to Monthly Revenue by combining to Funding Types
1. Load Monthly Revenue to DB

#### data

- `towns.csv` maps towns to regions

#### sql/functions/

- `ecis_enrollment_extraction.sql` - raw SQL to pull data from ECIS database 

#### TODOs

- Identify parent organizations for sites in ECIS
- Get rate and revenue numbers for historical CDC data and non-CDC Funding Sources
- Determine logic for C4K fundings and other fundings and start dates, these live in `Enrollment.AdditionalFundingSources`
- Check for active users, check if they have aged out
- Deduplicate sites across ECIS and ECE
- Site licence number in ECIS
- Accredited and Title I flags for ECIS
- Does Wraparound in ECIS directly correspond to part time? 
- What time field should be used for active month? (Enrollment Funding has some 1900 dates)
- Duplicate enrollments and Fundings are created for the same time for the same child

## Tests

Tests are set up to be run in an Azure Pipeline using the Docker Compose setup created in docker-compose.yml.
The tests run against a dummy SQL Server database set up in tests/test_data. `test_build_custom_report.py` should 
be run first since it builds the reports that the other tests check to ensure they have run properly.
