import boto3
import json
import os
import logging

# Initialize logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()

# AWS Clients
cloudwatch = boto3.client("cloudwatch")
dynamodb = boto3.client("dynamodb")
kinesis = boto3.client("kinesis")
sns = boto3.client("sns")

# Dynamic environment variables
DASHBOARD_NAME = os.getenv("DASHBOARD_NAME", "DynamoDB & Kinesis Monitoring Dashboard")
SNS_TOPIC_ARN = os.getenv("SNS_TOPIC_ARN", "")
AWS_REGION = os.getenv("AWS_REGION")  
AWS_ACCOUNT_ID = os.getenv("AWS_ACCOUNT_ID")  

ALLOWED_CATEGORIES = {"mesh", "wallet"}
EXCLUDED_APPLICATIONS = {"mesh-di", "mesh-zelle"}

def get_tagged_dynamodb_tables():
    """Retrieve DynamoDB tables tagged with 'ews:category' as 'mesh' or 'wallet' and exclude tables with 'ews:application' as 'mesh-di' or 'mesh-zelle'."""
    try:
        table_names = dynamodb.list_tables().get("TableNames", [])
        tagged_tables = set()

        for table_name in table_names:
            try:
                response = dynamodb.list_tags_of_resource(
                    ResourceArn=f"arn:aws:dynamodb:{AWS_REGION}:{AWS_ACCOUNT_ID}:table/{table_name}"
                )
                tags = {tag["Key"]: tag["Value"] for tag in response.get("Tags", [])}
                if tags.get("ews:category") in ALLOWED_CATEGORIES and tags.get("ews:application") not in EXCLUDED_APPLICATIONS:
                    tagged_tables.add(table_name)
            except Exception as e:
                logger.warning(f"⚠️ Failed to fetch tags for table {table_name}: {e}")

        logger.info(f"🔍 Tagged DynamoDB tables: {tagged_tables}")
        return tagged_tables

    except Exception as e:
        logger.error(f"❌ Error fetching DynamoDB tags: {e}")
        return set()


def get_tagged_kinesis_streams():
    """Retrieve Kinesis streams tagged with 'ews:category' as 'mesh' or 'wallet' and exclude streams with 'ews:application' as 'mesh-di' or 'mesh-zelle'."""
    try:
        response = kinesis.list_streams()
        stream_names = response.get("StreamNames", [])
        tagged_streams = set()

        for stream_name in stream_names:
            try:
                response = kinesis.list_tags_for_stream(StreamName=stream_name)
                tags = {tag["Key"]: tag["Value"] for tag in response.get("Tags", [])}
                if tags.get("ews:category") in ALLOWED_CATEGORIES and tags.get("ews:application") not in EXCLUDED_APPLICATIONS:
                    tagged_streams.add(stream_name)
            except Exception as e:
                logger.warning(f"⚠️ Failed to fetch tags for stream {stream_name}: {e}")

        logger.info(f"🔍 Tagged Kinesis streams: {tagged_streams}")
        return tagged_streams

    except Exception as e:
        logger.error(f"❌ Error fetching Kinesis tags: {e}")
        return set()


def build_dashboard_body(dynamodb_tables, kinesis_streams):
    """Builds a valid JSON structure for the CloudWatch Dashboard."""
    return {
        "widgets": [
            {
                "height": 1, "width": 24, "y": 0, "x": 0, "type": "text",
                "properties": {"markdown": "### DynamoDB & Kinesis Monitoring Dashboard"}
            },
            {
                "height": 6, "width": 24, "y": 1, "x": 0, "type": "metric",
                "properties": {
                    "title": "DynamoDB Read Requests (ms)", "view": "timeSeries", "stacked": False,
                    "region": AWS_REGION, "stat": "Average", "period": 60,
                    "metrics": [
                        ["AWS/DynamoDB", "SuccessfulRequestLatency", "TableName", table, "Operation", operation,
                         {"stat": "Average", "region": AWS_REGION}]
                        for table in dynamodb_tables
                        for operation in ["Scan", "GetItem"]
                    ]
                }
            },
            {
                "height": 6, "width": 12, "y": 7, "x": 0, "type": "metric",
                "properties": {
                    "title": "DynamoDB Latency (ms) by Operation", "view": "timeSeries", "stacked": False,
                    "region": AWS_REGION, "period": 300,
                    "metrics": [
                        ["AWS/DynamoDB", "SuccessfulRequestLatency", "TableName", table, "Operation", operation,
                         {"stat": "Average", "region": AWS_REGION}]
                        for table in dynamodb_tables
                        for operation in ["Query", "UpdateItem", "PutItem", "BatchWriteItem", "DeleteItem"]
                    ]
                }
            },
            {
                "height": 6, "width": 12, "y": 13, "x": 0, "type": "metric",
                "properties": {
                    "title": "DynamoDB Provisioned Read Capacity", "view": "timeSeries", "stacked": False,
                    "region": AWS_REGION, "period": 300,
                    "metrics": [
                        ["AWS/DynamoDB", "ProvisionedReadCapacityUnits", "TableName", table,
                         {"stat": "Average", "region": AWS_REGION}]
                        for table in dynamodb_tables
                    ]
                }
            },
            {
                "height": 6, "width": 12, "y": 7, "x": 12, "type": "metric",
                "properties": {
                    "title": "Kinesis GetRecords Metrics", "view": "timeSeries", "stacked": False,
                    "region": AWS_REGION, "period": 300,
                    "metrics": [
                        ["AWS/Kinesis", metric, "StreamName", stream, {"stat": stat, "region": AWS_REGION}]
                        for stream in kinesis_streams
                        for metric, stat in [
                            ("GetRecords.Bytes", "Sum"),
                            ("GetRecords.IteratorAgeMilliseconds", "Maximum"),
                            ("GetRecords.Latency", "Average"),
                            ("GetRecords.Records", "Sum")
                        ]
                    ]
                }
            },
            {
                "height": 6, "width": 12, "y": 13, "x": 12, "type": "metric",
                "properties": {
                    "title": "Kinesis PutRecords Metrics", "view": "timeSeries", "stacked": False,
                    "region": AWS_REGION, "period": 300,
                    "metrics": [
                        ["AWS/Kinesis", metric, "StreamName", stream, {"stat": stat, "region": AWS_REGION}]
                        for stream in kinesis_streams
                        for metric, stat in [
                            ("PutRecords.FailedRecords", "Sum"),
                            ("PutRecords.TotalRecords", "Sum"),
                            ("PutRecords.FailedRecords.Percent", "Average"),
                            ("WriteProvisionedThroughputExceeded", "Average"),
                            ("PutRecords.ThrottleRecords", "Sum")
                        ]
                    ]
                }
            }
        ]
    }


def update_cloudwatch_dashboard(dynamodb_tables, kinesis_streams):
    """Updates the CloudWatch Dashboard with new DDB tables & Kinesis streams."""
    try:
        dashboard_body = json.dumps(build_dashboard_body(dynamodb_tables, kinesis_streams), indent=2)
        response = cloudwatch.put_dashboard(
            DashboardName=DASHBOARD_NAME,
            DashboardBody=dashboard_body
        )
        logger.info(f"✅ CloudWatch Dashboard updated successfully: {response}")
    except Exception as e:
        logger.error(f"❌ Error updating CloudWatch dashboard: {e}")


def send_sns_notification(new_dynamodb, new_kinesis):
    """Send an SNS notification if new services are detected."""
    try:
        if new_dynamodb or new_kinesis:
            message = "**New AWS services detected:**\n\n"

            if new_dynamodb:
                message += "**DynamoDB Tables:**\n" + "\n".join(f"- {table}" for table in new_dynamodb) + "\n\n"

            if new_kinesis:
                message += "**Kinesis Streams:**\n" + "\n".join(f"- {stream}" for stream in new_kinesis) + "\n"

            sns.publish(TopicArn=SNS_TOPIC_ARN, Message=message, Subject="Dashboard Update: New Services Detected")
            logger.info(f"📢 SNS Notification sent:\n{message}")
        else:
            logger.info("ℹ️ No new services detected, no SNS notification sent.")

    except Exception as e:
        logger.error(f"❌ Error sending SNS notification: {e}")


def lambda_handler(event, context):
    """AWS Lambda entry point."""
    new_dynamodb = list(get_tagged_dynamodb_tables())
    new_kinesis = list(get_tagged_kinesis_streams())

    if new_dynamodb or new_kinesis:
        update_cloudwatch_dashboard(new_dynamodb, new_kinesis)
        send_sns_notification(new_dynamodb, new_kinesis)

    return {"status": "Dashboard updated", "new_dynamodb": new_dynamodb, "new_kinesis": new_kinesis}
