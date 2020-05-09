#!/usr/bin/env bash
# Wait for DB to come up
set -e
while ! /opt/mssql-tools/bin/sqlcmd -S test_db -U sa -P TestPassword1 -q 'select 1';
do
echo "waiting"
sleep 10
done
/opt/mssql-tools/bin/sqlcmd -S test_db -U sa -P TestPassword1 -q 'CREATE TABLE new_table (a int, b int)';

/opt/mssql-tools/bin/sqlcmd -S test_db -U sa -P TestPassword1 -q 'INSERT INTO new_table VALUES (1,2), (2,3)';

pytest tests/ --junitxml=junit/test-results.xml
