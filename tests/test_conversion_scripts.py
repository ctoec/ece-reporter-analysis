import unittest
import us
from analytic_tables.conversion_functions import validate_and_convert_state


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


if __name__ == '__main__':
    unittest.main()
