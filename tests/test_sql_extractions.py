import unittest
import sqlalchemy
import time
import pandas as pd


class TestSQLExtraction(unittest.TestCase):

	def test_dummy(self):
		self.assertIn(1, [1, 2, 3])

	@classmethod
	def setUpClass(cls):
		"""
		Connect to database and set access to engine for all
		:return:
		"""
		conn_string = f"mssql+pyodbc://sa:TestPassword1@test_db/master?driver=ODBC+Driver+17+for+SQL+Server&Mars_Connection=Yes"
		engine = sqlalchemy.create_engine(conn_string)

		# Build in a wait to check for db coming up
		cls.conn = engine.connect()

	# def test_enrollment_call(self):
	# 	query = pd.read_sql(sql='select * from CDCMonthlyEnrollmentReporting(2290)', con=self.conn)

	# def test_inssert

	# def test_foster_child(self):
	# 	query = 'select TOP 10 * FROM Enrollment'
	# 	df = pd.read_sql(query, self.engine)
	# 	self.assertIn('Id', df)


# Check valid foster logic

if __name__ == '__main__':
	unittest.main()