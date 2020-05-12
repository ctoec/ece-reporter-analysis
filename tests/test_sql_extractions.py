import unittest
import sqlalchemy
import time
import pandas as pd

FT = 'FT'
PT = 'PT'
INFANT = 'Infant/Toddler'
PRESCHOOL = 'Preschool'
SCHOOL_AGE = 'School-age'


class TestSQLExtraction(unittest.TestCase):

	@classmethod
	def setUpClass(cls):
		"""
		Connect to database and set access to engine for all, runs before all other tests
		"""
		conn_string = f"mssql+pyodbc://sa:TestPassword1@test_db/master?driver=ODBC+Driver+17+for+SQL+Server&Mars_Connection=Yes"
		engine = sqlalchemy.create_engine(conn_string)

		# Build in a wait to check for db coming up
		cls.conn = engine.connect()

	def test_unsubmitted_enrollment_report(self):

		# Test that an unsubmitted report returns an empty dataframe
		ret = pd.read_sql(sql='select * from CDCMonthlyEnrollmentReporting(2293)', con=self.conn)
		self.assertEqual(len(ret), 0)

	def test_extra_revenue(self):

		# Check that extra revenue from reports is included correctly
		query = 'select C4KRevenue, FamilyFeesRevenue from MonthlyOrganizationRevenueReporting where ReportId = 2292'
		c4k_revenue, family_fees = self.conn.execute(query).fetchall()[0]
		self.assertEqual(float(c4k_revenue), 1234.56)
		self.assertEqual(float(family_fees), 1000.50)

	def test_space_capacity(self):
		"""
		Check that summary tables are filled with expected data for capacity
		"""
		# Get capacity numbers from summary tables
		query = 'select TimeName, AgeGroupName, Capacity from MonthlyOrganizationSpaceReporting where ReportId = 2292'
		df = pd.read_sql(sql=query, con=self.conn, index_col=['TimeName', 'AgeGroupName'])
		lookup_dict = df.to_dict()['Capacity']

		# Check that numbers match expected numbers from SQL inserts
		self.assertEqual(lookup_dict[(FT, INFANT)], 10)
		self.assertEqual(lookup_dict[(PT, INFANT)], 2)
		self.assertEqual(lookup_dict[(FT, PRESCHOOL)], 20)
		self.assertEqual(lookup_dict[(PT, PRESCHOOL)], 5)
		self.assertEqual(lookup_dict[(FT, SCHOOL_AGE)], 1)

	def test_space_utilization(self):

		query = 'select TimeName, AgeGroupName, UtilizedSpaces, UtilizedNonTitle1Spaces, UtilizedTitleISpaces' \
				' from MonthlyOrganizationSpaceReporting where ReportId = 2292'
		df = pd.read_sql(sql=query, con=self.conn, index_col=['TimeName', 'AgeGroupName'])
		lookup_dict = df.to_dict()

		# Check summed utilized numbers
		total_dict = lookup_dict['UtilizedSpaces']
		self.assertEqual(total_dict[(FT, INFANT)], 5)
		self.assertEqual(total_dict[(PT, INFANT)], 2)
		self.assertEqual(total_dict[(FT, PRESCHOOL)], 1)
		self.assertEqual(total_dict[(PT, PRESCHOOL)], 1)
		self.assertEqual(total_dict[(FT, SCHOOL_AGE)], 1)

		# Check TitleI utilized numbers
		title_one_dict = lookup_dict['UtilizedTitleISpaces']
		self.assertEqual(title_one_dict[(FT, INFANT)], 1)

		# Check Standard utilized numbers
		non_title_one_dict = lookup_dict['UtilizedNonTitle1Spaces']
		self.assertEqual(non_title_one_dict[(FT, INFANT)], 4)
		self.assertEqual(non_title_one_dict[(PT, INFANT)], 2)
		self.assertEqual(non_title_one_dict[(FT, PRESCHOOL)], 1)
		self.assertEqual(non_title_one_dict[(PT, PRESCHOOL)], 1)
		self.assertEqual(non_title_one_dict[(FT, SCHOOL_AGE)], 1)

	def test_cdc_revenue(self):

		# Test summation of CDC Revenue
		query = 'select CDCRevenue From MonthlyOrganizationRevenueReporting'
		revenue = self.conn.execute(query).fetchall()[0][0]
		self.assertEqual(float(revenue), 6632.20)

		# Test that breakdown of revenue is correct
		query = 'SELECT AgeGroupName,TimeName, Sum(CDCRevenue) AS Revenue ' \
				'FROM MonthlyEnrollmentReporting ' \
				'where ReportId = 2292 ' \
				'GROUP BY AgeGroupName, TimeName'

		df = pd.read_sql(sql=query, con=self.conn, index_col=['TimeName', 'AgeGroupName'])





if __name__ == '__main__':
	unittest.main()