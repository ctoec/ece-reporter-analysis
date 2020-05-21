from resource_access.constants import ECE_DB_SECTION
from resource_access.connections import get_mysql_connection
from analytic_tables import MonthlyEnrollmentReporting, MonthlyOrganizationRevenueReporting, MonthlyOrganizationSpaceReporting

if __name__ == '__main__':
    # Connect to database
    engine = get_mysql_connection(ECE_DB_SECTION)

    # Create all analytic tables
    MonthlyEnrollmentReporting.MonthlyEnrollmentReporting.metadata.create_all(engine)
    MonthlyOrganizationSpaceReporting.MonthlyOrganizationSpaceReporting.metadata.create_all(engine)
    MonthlyOrganizationRevenueReporting.MonthlyOrganizationRevenueReporting.metadata.create_all(engine)
