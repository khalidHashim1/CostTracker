import boto3
import json
from datetime import datetime, timedelta, timezone

S3_BUCKET = "cost.khalidhashim.com"
S3_KEY = "aws_cost_dashboard.json"

SERVICE_MAPPING = {
    "Amazon S3": "File Storage",
    "Amazon EC2": "Compute",
    "AWS Lambda": "Compute",
    "Amazon RDS": "Database",
    "Amazon DynamoDB": "Database",
    "Amazon CloudFront": "Network",
    "AWS Support": "Support"
}

def map_service(service_name):
    for key, category in SERVICE_MAPPING.items():
        if key in service_name:
            return category
    return "Other"

def lambda_handler(event, context):
    ce = boto3.client('ce', region_name='us-east-1')

    end = datetime.now(timezone.utc).date()
    start = end - timedelta(days=14)

    response = ce.get_cost_and_usage(
        TimePeriod={
            'Start': start.isoformat(),
            'End': end.isoformat()
        },
        Granularity='DAILY',
        Metrics=['UnblendedCost'],
        GroupBy=[{'Type': 'DIMENSION', 'Key': 'SERVICE'}]
    )

    daily_data = {}

    for day in response['ResultsByTime']:
        date = day['TimePeriod']['Start']
        daily_data[date] = {}

        for group in day['Groups']:
            service = group['Keys'][0]
            cost = float(group['Metrics']['UnblendedCost']['Amount'])
            category = map_service(service)

            daily_data[date][category] = daily_data[date].get(category, 0) + cost

    output = []
    for date, categories in sorted(daily_data.items()):
        total = round(sum(categories.values()), 2)
        output.append({
            "date": date,
            "total": total,
            "categories": {k: round(v, 2) for k, v in categories.items()}
        })

    s3 = boto3.client('s3')
    s3.put_object(
        Bucket=S3_BUCKET,
        Key=S3_KEY,
        Body=json.dumps(output),
        ContentType="application/json",
        
    )

    return {
        "statusCode": 200,
        "headers": {
            "Access-Control-Allow-Origin": "*"
        },
        "body": json.dumps("Cost dashboard updated")
    }
