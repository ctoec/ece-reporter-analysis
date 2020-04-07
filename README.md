# ece-reporter-analysis

This repository contains code to support one-off and ongoing reports from data collected by ECE Reporter and potentially other data sources in the future. 

## Folders

### SQL
Code exposing 
- init.sql: Table creation scripts for analysis tables
- functions.sql: Custom SQL functions ranged by time period that return tables to be inserted in base analytics tables following validation.
- temp_load.sql: Use function to add a small snapshot of data to power a POC looking at the analytics tables.

## data
Static tables added manually to the database, these may be updated sporatically.
- IncomeLevels: Income levels by family size for 75% of State Median Income and 200% of Federal Poverty Level.
- Rates: Pre-set rates for Child Day Care slots based on various child and site characteristics. 
