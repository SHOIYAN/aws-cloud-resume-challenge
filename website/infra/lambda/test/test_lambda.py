import sys
import os
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))




# test_lambda.py

import pytest
from unittest.mock import MagicMock

@pytest.fixture
def mock_dynamodb_table(mocker):
    return mocker.Mock()

def test_lambda_handler(mocker, mock_dynamodb_table):
    # Your test logic using mock_dynamodb_table
    pass






# test_lambda.py

from unittest.mock import MagicMock
from lambda_function import lambda_handler

def test_lambda_handler(mocker, mock_dynamodb_table):
    # Set up the mock DynamoDB table with the expected item
    mock_dynamodb_table.get_item.return_value = {
        'Item': {'id': '0', 'views': 5}  # Example existing item with 5 views
    }

    # Call the lambda_handler function
    event = {}  # Assuming an empty event
    context = None  # Passing None as context since it's not used in your lambda_handler function
    response = lambda_handler(event, context)

    # Assertions
    assert response == 6  # Expecting views to be incremented by 1

    # Ensure that put_item was called with the updated views
    mock_dynamodb_table.put_item.assert_called_once_with(Item={'id': '0', 'views': 6})

# test_lambda.py
# test_lambda.py









