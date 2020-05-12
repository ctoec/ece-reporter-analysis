#!/usr/bin/env bash
# Wait for DB to come up
set -e
while ! /opt/mssql-tools/bin/sqlcmd -S test_db -U sa -P TestPassword1 -q 'select 1';
do
echo "waiting for DB"
sleep 10
done

# Add dummy table to run python test against
/opt/mssql-tools/bin/sqlcmd -S test_db -U sa -P TestPassword1 -q 'CREATE TABLE new_table (a int, b int, c int)';
/opt/mssql-tools/bin/sqlcmd -S test_db -U sa -P TestPassword1 -q 'INSERT INTO new_table VALUES (1,2, 4), (2,3, 4)';

# Run tests and write results to test volume for printing
pytest tests/ --junitxml=tests/test-results.xml
