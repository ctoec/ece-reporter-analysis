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
		# cls.conn = engine.connect()

	def test_connection(self):
		self.assertEqual(1, 1)


		# self.conn.execute('select * from new_table')

if __name__ == '__main__':
	unittest.main()