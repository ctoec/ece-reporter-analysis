from datetime import datetime
import unittest
import us
from analytic_tables.conversion_functions import validate_and_convert_state, get_beginning_and_end_of_month


class TestConversionScript(unittest.TestCase):

    def test_states(self):

        valid_ct_strings_list = ['CT', 'ct', 'Connecticut', 'connecticut', 'CT']

        for ct_string in valid_ct_strings_list:
            res = validate_and_convert_state(ct_string)
            self.assertEqual(us.states.CT.abbr, res)

        invalid_list = ['Connect', '', None]
        for string in invalid_list:
            res = validate_and_convert_state(string)
            self.assertEqual(None, res)

    def test_beginning_and_end_of_month(self):

        june = datetime.strptime('2020-06-15', '%Y-%m-%d')
        june_start, june_end = get_beginning_and_end_of_month(june)
        self.assertEqual(june_start, datetime.strptime('2020-06-01', '%Y-%m-%d'))
        self.assertEqual(june_end, datetime.strptime('2020-06-30', '%Y-%m-%d'))

        august = datetime.strptime('2020-08-01', '%Y-%m-%d')
        august_start, august_end = get_beginning_and_end_of_month(august)
        self.assertEqual(august_start, datetime.strptime('2020-08-01', '%Y-%m-%d'))
        self.assertEqual(august_end, datetime.strptime('2020-08-31', '%Y-%m-%d'))
        
        feb_non_leap = datetime.strptime('2021-02-02', '%Y-%m-%d')
        february_start, february_end = get_beginning_and_end_of_month(feb_non_leap)
        self.assertEqual(february_start, datetime.strptime('2021-02-01', '%Y-%m-%d'))
        self.assertEqual(february_end, datetime.strptime('2021-02-28', '%Y-%m-%d'))

        feb_leap = datetime.strptime('2020-02-29', '%Y-%m-%d')
        february_start_leap, february_end_leap = get_beginning_and_end_of_month(feb_leap)
        self.assertEqual(february_start_leap, datetime.strptime('2020-02-01', '%Y-%m-%d'))
        self.assertEqual(february_end_leap, datetime.strptime('2020-02-29', '%Y-%m-%d'))
        

if __name__ == '__main__':
    unittest.main()
