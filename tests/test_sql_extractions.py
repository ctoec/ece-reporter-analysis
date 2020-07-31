import unittest
import pandas as pd
from resource_access.connections import get_mysql_connection
from resource_access.constants import ECE_DB_SECTION
FT = 'FT'
PT = 'PT'
INFANT = 'Infant/Toddler'
PRESCHOOL = 'Preschool'
SCHOOL_AGE = 'School-age'


class TestSQLExtractionFromDummy(unittest.TestCase):

	@classmethod
	def setUpClass(cls):
		"""
		Connect to database and set access to engine for all, runs before all other tests
		"""
		engine = get_mysql_connection(ECE_DB_SECTION)

		# Build in a wait to check for db coming up
		cls.conn = engine.connect()

	def test_extra_revenue(self):

		# Check that extra revenue from reports is included correctly
		query = 'select C4KRevenue, FamilyFeesRevenue from pensieve.MonthlyOrganizationRevenueReporting where ReportId = 2292'
		c4k_revenue, family_fees = self.conn.execute(query).fetchall()[0]
		self.assertEqual(float(c4k_revenue), 1234.56)
		self.assertEqual(float(family_fees), 1000.50)

	def test_space_capacity(self):
		"""
		Check that summary tables are filled with expected data for capacity
		"""
		# Get capacity numbers from summary tables
		query = 'select CDCTimeName, CDCAgeGroupName, Capacity from pensieve.MonthlyOrganizationSpaceReporting where ReportId = 2292'
		df = pd.read_sql(sql=query, con=self.conn, index_col=['CDCTimeName', 'CDCAgeGroupName'])
		lookup_dict = df.to_dict()['Capacity']

		# Check that numbers match expected numbers from SQL inserts
		self.assertEqual(lookup_dict[(FT, INFANT)], 10)
		self.assertEqual(lookup_dict[(PT, INFANT)], 2)
		self.assertEqual(lookup_dict[(FT, PRESCHOOL)], 20)
		self.assertEqual(lookup_dict[(PT, PRESCHOOL)], 5)
		self.assertEqual(lookup_dict[(FT, SCHOOL_AGE)], 1)

	def test_space_utilization(self):

		query = 'select CDCTimeName, CDCAgeGroupName, UtilizedSpaces, UtilizedNonTitle1Spaces, UtilizedTitleISpaces' \
				' from pensieve.MonthlyOrganizationSpaceReporting where ReportId = 2292'
		df = pd.read_sql(sql=query, con=self.conn, index_col=['CDCTimeName', 'CDCAgeGroupName'])
		lookup_dict = df.to_dict()

		# Check summed utilized numbers
		total_dict = lookup_dict['UtilizedSpaces']
		self.assertEqual(total_dict[(FT, INFANT)], 6)
		self.assertEqual(total_dict[(PT, INFANT)], 2)
		self.assertEqual(total_dict[(FT, PRESCHOOL)], 1)
		self.assertEqual(total_dict[(PT, PRESCHOOL)], 1)
		self.assertEqual(total_dict[(FT, SCHOOL_AGE)], 1)

		# Check TitleI utilized numbers
		title_one_dict = lookup_dict['UtilizedTitleISpaces']
		self.assertEqual(title_one_dict[(FT, INFANT)], 1)

		# Check Standard utilized numbers
		non_title_one_dict = lookup_dict['UtilizedNonTitle1Spaces']
		self.assertEqual(non_title_one_dict[(FT, INFANT)], 5)
		self.assertEqual(non_title_one_dict[(PT, INFANT)], 2)
		self.assertEqual(non_title_one_dict[(FT, PRESCHOOL)], 1)
		self.assertEqual(non_title_one_dict[(PT, PRESCHOOL)], 1)
		self.assertEqual(non_title_one_dict[(FT, SCHOOL_AGE)], 1)

	def test_cdc_revenue(self):

		# Test summation of CDC Revenue
		query = 'select CDCRevenue From pensieve.MonthlyOrganizationRevenueReporting'
		revenue = self.conn.execute(query).fetchall()[0][0]
		self.assertEqual(round(float(revenue), 2), 7481.95)

		# Test that breakdown of revenue is correct
		query = 'SELECT CDCAgeGroupName,CDCTimeName, Sum(CDCRevenue) AS Revenue ' \
				'FROM pensieve.MonthlyEnrollmentReporting ' \
				'where ReportId = 2292 ' \
				'GROUP BY CDCAgeGroupName, CDCTimeName'

		df = pd.read_sql(sql=query, con=self.conn, index_col=['CDCAgeGroupName', 'CDCTimeName'])
		lookup_dict = df.to_dict()['Revenue']
		# Check breakdown of revenue by type
		self.assertEqual(5205.10, round(float(lookup_dict[(INFANT, FT)]),2))
		self.assertEqual(595.00, round(float(lookup_dict[(INFANT, PT)]),2))
		self.assertEqual(826.60, round(float(lookup_dict[(PRESCHOOL, FT)]),2))
		self.assertEqual(289.25, round(float(lookup_dict[(PRESCHOOL, PT)]),2))
		self.assertEqual(566.00, round(float(lookup_dict[(SCHOOL_AGE, FT)]),2))

	def test_count_number_of_families(self):

		query = """
		SELECT     FamilySize,
        COUNT(DISTINCT(SourceChildId)) AS NumberOfFamilies
		FROM pensieve.MonthlyEnrollmentReporting
		WHERE Under200FPL = 1
		GROUP BY FamilySize"""

		lookup_dict = pd.read_sql(sql=query, con=self.conn, index_col='FamilySize').to_dict()['NumberOfFamilies']

		self.assertEqual(lookup_dict[1], 1)
		self.assertEqual(lookup_dict[3], 5)
		self.assertEqual(lookup_dict[4], 1)
		self.assertEqual(lookup_dict[5], 1)
		self.assertEqual(lookup_dict[9], 1)

	def test_c4k_certificate(self):

		query = 'select count(*) from pensieve.MonthlyEnrollmentReporting WHERE ActiveC4K = 1'
		active_c4k_certificates = self.conn.execute(query).fetchall()[0][0]
		self.assertEqual(active_c4k_certificates, 1)


if __name__ == '__main__':
	unittest.main()