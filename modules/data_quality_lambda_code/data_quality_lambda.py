import json
import boto3
import time
import csv
from botocore.exceptions import ClientError
from datetime import datetime

athena_client = boto3.client("athena")
INITIAL_WAIT_TIME = 5
MAX_RETRIES = 2


def load_lookup_csv(LOOKUP_BUCKET, DATA_QUALITY_LOOKUP_SHEET):
    try:
        s3_client = boto3.client("s3")
        file_object = s3_client.get_object(
            Bucket=LOOKUP_BUCKET, Key=DATA_QUALITY_LOOKUP_SHEET
        )
        data = file_object["Body"].read().decode("utf-8").splitlines()
        reader = csv.reader(data)
        next(reader)
        return list(reader)
    except ClientError as e:
        print(f"Error while loading {DATA_QUALITY_LOOKUP_SHEET} sheet {e}")
    except Exception as e:
        print(f"Exception while loading {DATA_QUALITY_LOOKUP_SHEET} sheet {e}")


def execute_athena_sql_query(rule_name, database, sql_query, ATHENA_OUTPUT_BUCKET):
    try:
        response = athena_client.start_query_execution(
            QueryString=sql_query,
            QueryExecutionContext={"Database": database},
            ResultConfiguration={"OutputLocation": ATHENA_OUTPUT_BUCKET},
        )

        query_execution_id = response["QueryExecutionId"]

        wait_time = INITIAL_WAIT_TIME
        for _ in range(MAX_RETRIES):
            response_status = athena_client.get_query_execution(
                QueryExecutionId=query_execution_id
            )
            status = response_status["QueryExecution"]["Status"]["State"]

            if status == "SUCCEEDED":
                #print(f"Query Succeeded: {query_execution_id}")
                return query_execution_id
            elif status in ("FAILED", "CANCELLED"):
                print(f"Rule: {rule_name} | Query Failed: {query_execution_id} | Status: {status}")
                return None

            time.sleep(wait_time)
            wait_time = min(wait_time * 2, 30)

        print(f"Query Timeed Out for the rule {rule_name}")
        athena_client.stop_query_execution(query_execution_id)
    except ClientError as e:
        print(f"Athena Client Error: {e}")
    except Exception as e:
        print(f"Athena Query Error: {e}")
    return None


def get_query_result(query_execution_id):

    if not query_execution_id:
        return -1

    try:
        result_response = athena_client.get_query_results(
            QueryExecutionId=query_execution_id
        )
        rows = result_response.get("ResultSet", {}).get("Rows", [])

        if len(rows) > 1 and "VarCharValue" in rows[1]["Data"][0]:
            return int(rows[1]["Data"][0]["VarCharValue"])
    except ClientError as e:
        print(f"Get Query Results Error: {e}")
    except Exception as e:
        print("Get Query Result Exception: {e}")
    return -1


def lambda_handler(event, context):
    lambda_name=context.function_name
    env=lambda_name.split("-")[0]
    region=lambda_name.split("-")[1]
    
    LOOKUP_BUCKET = '{}-{}-wallet-wallet-sre-operational-s3'.format(env,region)
    DATA_QUALITY_LOOKUP_SHEET = "data_quality_lookup.csv"
    ATHENA_OUTPUT_BUCKET = 's3://{}-{}-wallet-wallet-sre-query-results-s3/'.format(env,region)

    try:
        data_quality_list = load_lookup_csv(LOOKUP_BUCKET,DATA_QUALITY_LOOKUP_SHEET)
        if not data_quality_list:
            return {
                "status_code": 500,
                "body": json.dumps("Failed to load {DATA_QUALITY_LOOKUP_SHEET}"),
            }

        for monitoring_record in data_quality_list:
            if monitoring_record[5] == "Active":
                rule_id, rule_name, database, sql_query, threshold = (
                    monitoring_record[0],
                    monitoring_record[1],
                    monitoring_record[2],
                    monitoring_record[3],
                    monitoring_record[4],
                )

                try:
                    query_execution_id = execute_athena_sql_query(
                        rule_name, database, sql_query, ATHENA_OUTPUT_BUCKET
                    )
                    print(f"Rule: {rule_name} | query_execution_id is : {query_execution_id}")
                    
                    record_count = None
                    if query_execution_id is not None:
                        record_count = get_query_result(query_execution_id)
                    else:
                        print(f"Unable to fetch the result for the rule: {rule_name}")
                        
                                         
                    current_time = datetime.now()
                    validation_status = ""

                    if (record_count == -1 or record_count is None):
                        validation_status = "Error"
                    else:
                        validation_status = (
                            "Success" if record_count <= int(threshold) else "Failed"
                        )

                    print(
                        f"Data Quality Validation Result: Time {current_time} | Rule_Id: {rule_id} | Rule_Name: {rule_name} | Status: {validation_status} | Count: {record_count} | Threshold: {threshold}"
                    )
                except Exception as e:
                    print(f"Query Execution failed for the rule {rule_name}: {e}")
                    print(
                        f"Data Quality Validation Result: Time {current_time} | Rule_Id: {rule_id} | Rule_Name: {rule_name} | Status: {validation_status} | Count: {record_count} | Threshold: {threshold}"
                    )
        return {"status_code": 200}
    except Exception as e:
        print(f"lambda handler Error: {e}")
        return {
            "status_code": 500,
            "body": json.dumps("An error occurred with lambda: {e}"),
        }