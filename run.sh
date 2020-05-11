#!/usr/bin/env bash
set -e

# Wait for DB to come up
while ! /opt/mssql-tools/bin/sqlcmd -S test_db -U sa -P TestPassword1 -q 'select 1';
do
echo "waiting"
sleep 10
done

# Run tests and write results to volumes
pytest tests/ --junitxml=tests/test-results.xml
