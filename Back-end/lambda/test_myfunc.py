import unittest
from unittest.mock import patch
from io import StringIO


# Mocking boto3 DynamoDB client
@patch('boto3.resource')
class TestLambdaHandler(unittest.TestCase):

    @patch('sys.stdout', new_callable=StringIO)
    def test_lambda_handler_prints_numbers(self, mock_stdout, mock_dynamodb_resource):
        # Mock DynamoDB Table
        mock_table = mock_dynamodb_resource().Table.return_value
        mock_table.get_item.return_value = {'Item': {'id': '0', 'views': 1}}

        # Call the lambda_handler function
        from myfunc import lambda_handler
        event = {}
        context = {}
        result = lambda_handler(event, context)

        # Get the output from stdout
        output = mock_stdout.getvalue().strip()

        # Check if the output contains the numbers
        numbers = [int(num) for num in output.split('\n') if num.isdigit()]
        self.assertGreater(len(numbers), 0)  # Assert that at least one number was printed
        self.assertTrue(all(num >= 0 for num in numbers))  # Assert that all numbers are non-negative integers

        # Check the result returned by the function
        self.assertEqual(result, 2)  # Assuming the function increments 'views' by 1

if __name__ == '__main__':
    unittest.main()