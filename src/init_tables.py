from resource_access.constants import ECE_DB_SECTION
from resource_access.connections import get_mysql_connection
from analytic_tables.base_tables import Base

if __name__ == '__main__':
    # Connect to database
    engine = get_mysql_connection(ECE_DB_SECTION)

    # Create all analytic tables
    Base.metadata.create_all(engine)
