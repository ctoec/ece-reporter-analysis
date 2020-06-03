#!/usr/bin/env bash

# Wait for DB to come up to continue with tests
set -e
while ! /opt/mssql-tools/bin/sqlcmd -S test_db -U sa -P TestPassword1 -q 'select 1';
do
echo "waiting for DB"
sleep 10
done

# Add test data into database
./tests/build_local_test_data.sh

sleep 10000
export PYTHONPATH="${PYTHONPATH}:/src"

## Run tests and write results to test volume for printing
pytest tests/test_build_custom_report.py --junitxml=tests/test-load-results.xml
pytest tests/test_sql_extractions.py --junitxml=tests/test-results.xml
