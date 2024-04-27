import json
import boto3

dynamodb = boto3.resource('dynamodb', region_name='us-east-1')
table = dynamodb.Table ('cloudresume-test')
def lambda_handler(event,context):
    response = table.get_item(Key = {'id': '0'})
    views=response ['Item'] ['views']
    views = views + 1
    print (views)
    response = table.put_item (Item = {
        'id': '0',
        'views': views
        
    })
   
    
    return views







    
