import json
from unittest.mock import patch
from myfunc import lambda_handler  # Import your lambda handler function

# Mock the DynamoDB resource
@patch('boto3.resource')
def test_lambda_handler(mock_boto_resource):
    # Mock the DynamoDB table response
    mock_table = mock_boto_resource.return_value.Table.return_value
    mock_table.get_item.return_value = {'Item': {'views': 10}}

    # Simulate a GET request event
    event_get = {
        "httpMethod": "GET",
    }
    context = {}  # You can leave this empty for now
    response_get = lambda_handler(event_get, context)

    print("GET response:", response_get)  # Output the result for verification
    assert response_get['statusCode'] == 200
    assert "views" in json.loads(response_get['body'])

    # Simulate a POST request event
    event_post = {
        "httpMethod": "POST",
    }
    response_post = lambda_handler(event_post, context)

    print("POST response:", response_post)  # Output the result for verification
    assert response_post['statusCode'] == 200
    assert "message" in json.loads(response_post['body'])
    assert "views" in json.loads(response_post['body'])

# Run the test
test_lambda_handler()
