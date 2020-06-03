#!/usr/bin/env bash
TEST_DIR=/tests/test_data
SQL_FUNCTIONS_DIR=/sql/functions
SQL_TABLES_DIR=/sql/tables
set -e


# Load test data
for file in $TEST_DIR/*
do
  echo $file;
  /opt/mssql-tools/bin/sqlcmd -b -S test_db -U sa -P TestPassword1 -i /$file
done

export PYTHONPATH="${PYTHONPATH}:/src"
python3 src/init_tables.py