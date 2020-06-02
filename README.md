# oec-data-tools

This repository contains code to support collecting data from ECE Reporter and other sources and ingesting
it into a centralized analytics database.

## src

### analytic_tables

SQLAlchemy code that creates and represents base analytics tables. There are no migrations
as of 2020-06-02 but when they become necessary they will be run by [Alembic](https://pypi.org/project/alembic/). 

### ece_extraction

This code pulls data from ECE Reporter in an ordered manner than can be used in a potential future
ingestion framework. It breaks down the ingestion process into various extraction, transformation
and combination steps. 

The order of operations is:
1. Extract Enrollment data
1. Transform Enrollment

#### sql

SQL code used to extract key views from different tables in the ECE Reporter database. The resulting
dataframes are combined and transformed in the code in `src/ece_extraction/table_extraction.py`.

#### data
Static tables added manually to the database, these may be updated sporatically.
- IncomeLevels: Income levels by family size for 75% of State Median Income and 200% of Federal Poverty Level.
- Rates: Pre-set rates for Child Day Care slots based on various child and site characteristics. 

## Tests

Tests are set up to be run in an Azure Pipeline using the Docker Compose setup created in docker-compose.yml.
The tests run against a dummy SQL Server database set up in tests/test_data. 

### SQL
Code exposing 
- init.sql: Table creation scripts for analysis tables
- functions.sql: Custom SQL functions ranged by time period that return tables to be inserted in base analytics tables following validation.
- temp_load.sql: Use function to add a small snapshot of data to power a POC looking at the analytics tables.

## data
Static tables added manually to the database, these may be updated sporatically.
- IncomeLevels: Income levels by family size for 75% of State Median Income and 200% of Federal Poverty Level.
- Rates: Pre-set rates for Child Day Care slots based on various child and site characteristics. 
