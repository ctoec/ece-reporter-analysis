#!/usr/bin/env bash
TEST_DIR=/tests/test_data
SQL_FUNCTIONS_DIR=/sql/functions
SQL_TABLES_DIR=/sql/tables
set -e


# Load test data
for file in $TEST_DIR/*
do
  echo $file;
  /opt/mssql-tools/bin/sqlcmd -S test_db -U sa -P TestPassword1 -i /$file;
done

# Add in analysis tables
for file in $SQL_TABLES_DIR/*
do
  echo $file
  /opt/mssql-tools/bin/sqlcmd -S test_db -U sa -P TestPassword1 -i $file
done
#
# Add in extraction functions
for file in $SQL_FUNCTIONS_DIR/*
do
  echo $file
  /opt/mssql-tools/bin/sqlcmd -S test_db -U sa -P TestPassword1 -i $file;
done

# Build temporary tables
/opt/mssql-tools/bin/sqlcmd -S test_db -U sa -P TestPassword1 -i /sql/temp_load.sql
