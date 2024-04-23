import unittest
from unittest.mock import patch
from io import StringIO
from myfunc import lambda_handler

class TestLambdaHandler(unittest.TestCase):

    @patch('sys.stdout', new_callable=StringIO)
    def test_lambda_handler_prints_numbers(self, mock_stdout):
        # Call the lambda_handler function
        event = {}
        context = {}
        lambda_handler(event, context)

        # Get the output from stdout
        output = mock_stdout.getvalue().strip()

        # Check if the output contains the numbers
        numbers = [int(num) for num in output.split('\n') if num.isdigit()]
        self.assertGreater(len(numbers), 0)  # Assert that at least one number was printed
        self.assertTrue(all(num >= 0 for num in numbers))  # Assert that all numbers are non-negative integers

