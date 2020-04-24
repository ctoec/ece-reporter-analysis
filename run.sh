#!/usr/bin/env bash
# Wait for DB to come up
set -e
while ! /opt/mssql-tools/bin/sqlcmd -S test_db -U sa -P TestPassword1 -q 'select 1';
do
echo "waiting"
sleep 10
done

# Add test data into database
./tests/build_local_test_data.sh
pytest tests/
sleep 10000
