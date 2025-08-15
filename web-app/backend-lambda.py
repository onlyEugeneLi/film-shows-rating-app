import json
import boto3
from time import gmtime, strftime
import uuid  # for generating unique IDs

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('film-tracker-app-table')

def lambda_handler(event, context):
    # generate a unique ID for the review
    review_id = str(uuid.uuid4())

    # optional: capture current timestamp
    now = strftime("%Y-%m-%dT%H:%M:%SZ", gmtime())

    # write item to DynamoDB
    table.put_item(
        Item={
            'ID': review_id,
            'Title': event.get('title', ''),
            'Type': event.get('type', ''),
            'Score': int(event.get('score', 0)) if event.get('score') else None,
            'WatchedDate': event.get('watchedDate', None),
            'ReleaseYear': int(event.get('releaseYear')) if event.get('releaseYear') else None,
            'requestTime': now
        }
    )



    return {
        'statusCode': 200,
        'body': json.dumps({
            'message': f"Submission for '{event.get('title', 'Unknown')}' review successful"
        })
    }