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

The order of operations is:
1. Extract Enrollment data
1. Transform Enrollment data
   - Rename columns
   - Add booleans for income levels relative the state median income (SMI) and federal poverty level (FPL)
   - Check active C4K certificate
   - Add logic setting income to 0 and family size to 1 for foster children
   - Create boolean for children of more than one race
   - Calculate monthly rate
1. Load Enrollment data
1. Extract Capacity data
1. Combine Capacity data with Enrollment data to calculate Utilized Spaces
1. Load Capacity/Utilization data to DB
1. Extract Report Revenue data
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
on a monthly basis historically. As of 2020-06-11 the data is from a snapshot of the ECIS database
as of Feb. 2020.

#### TODOs

- Identify parent organizations for sites in ECIS
- Get rate and revenue numbers for historical CDC data and non-CDC Funding Sources
- Determine logic for C4K fundings and start dates, these live in `Enrollment.AdditionalFundingSources`
- Check for active users, check if they have aged out
- Schedule meeting with Julie after 6/24

## Tests

Tests are set up to be run in an Azure Pipeline using the Docker Compose setup created in docker-compose.yml.
The tests run against a dummy SQL Server database set up in tests/test_data. `test_build_custom_report.py` should 
be run first since it builds the reports that the other tests check to ensure they have run properly.
