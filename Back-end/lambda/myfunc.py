import json
import boto3
from decimal import Decimal

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('resume-db')

def lambda_handler(event, context):
    http_method = event['httpMethod']    

    if http_method == 'GET':
        response = table.get_item(Key={'id': '0'})
        views = response['Item']['views']
        
        return {
            "statusCode": 200,
            "headers": {
                "Access-Control-Allow-Origin": "*",
                "Content-Type": "application/json"
            },
            "body": json.dumps({"views": str(views)})
        }

    elif http_method == 'POST':
        response = table.get_item(Key={'id': '0'})
        views = response['Item']['views']
        views += 1
        table.put_item(Item={
            'id': '0',
            'views': views
        })

        return {
            "statusCode": 200,
            "headers": {
                "Access-Control-Allow-Origin": "*",
                "Content-Type": "application/json"
            },
            "body": json.dumps({"message": "Views updated", "views": str(views)})
        }

    else:
        return {
            "statusCode": 405,
            "headers": {
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": "*"
            },
            "body": json.dumps({"error": "Method not allowed"})
        }
