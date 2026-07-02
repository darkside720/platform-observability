import json
import boto3
import time
import csv
from botocore.exceptions import ClientError
from datetime import datetime

def execute_athena_query(alertDtl, database, sqlQuery, queryOutPutS3Bucket, retryCount):

    try:

        # client initialization
        client = boto3.client('athena')
        # connect the database to fetch data result
        response = client.start_query_execution(
            QueryString = sqlQuery,
            QueryExecutionContext={'Database': database},
            ResultConfiguration={'OutputLocation': queryOutPutS3Bucket}
        )

        print("Execution for "+ alertDtl + " :: database:: " + database + " sqlQuery:: "+ sqlQuery)


        # get query execution id
        query_execution_id = response["QueryExecutionId"]

        print(alertDtl + ":: QueryExecutionId is : " + query_execution_id)


        # Query queue wait timing
        time.sleep(15)

        for i in range(1, retryCount):

            print(alertDtl + " retry count is "+str(i)+"/"+str(retryCount))

            # get query execution
            response_get_query_details  = client.get_query_execution(QueryExecutionId=query_execution_id)

            print(response_get_query_details)

            status = response_get_query_details['QueryExecution']['Status']['State']

            if status == 'SUCCEEDED':
                print(alertDtl +" :: STATUS:" + status)
                break
            if (status == 'FAILED') or (status == 'CANCELLED'):
                raise Exception(alertDtl +" :: STATUS:" + status)
            else:
                print(alertDtl +" :: STATUS:" + status)
                time.sleep(10)
        else:
            client.stop_query_execution(QueryExecutionId=query_execution_id)
            raise Exception(alertDtl +" :: TIME OVER")

            # get query results
        query_result = client.get_query_results(QueryExecutionId=query_execution_id)
        print(alertDtl + " :: " + str(query_result))

    except ClientError as clienterror:
        print(clienterror.response)
    except Exception as exception:
        print("execute_athena_query :: " + alertDtl + " :: "+ str(exception))

def alertExecution(exeuctionFrequency, exeuctionHour, exeuctionDays):
    # print("Inside alertExecution :: "+ exeuctionFrequency + " :: " + exeuctionHour + " :: "+ exeuctionDays)
    if exeuctionFrequency == "Hourly":
        return True
    elif exeuctionFrequency == "Daily":
        if datetime.now().hour == int(exeuctionHour):
            return True
    elif exeuctionFrequency == "Weekly":
        if datetime.now().strftime("%a") in exeuctionDays and datetime.now().hour == int(exeuctionHour):
            return True
    else:
        return False


def lambda_handler(event, context):
    print("Inside lambda_handler")

    lambdaName=context.function_name
    env=lambdaName.split("-")[0]
    region=lambdaName.split("-")[1]

    lookupS3Bucket='{}-{}-wallet-wallet-sre-operational-s3'.format(env,region)
    lookUpSheet='sre-lookup.csv'
    queryOutPutS3Bucket='s3://{}-{}-wallet-wallet-sre-query-results-s3/'.format(env,region)

    retryCount = 2
    s3 = boto3.client('s3')

    try:
        obj = s3.get_object(Bucket=lookupS3Bucket, Key=lookUpSheet)
        data = obj['Body'].read().decode('utf-8').splitlines()
        monitoringList = csv.reader(data)
        headers = next(monitoringList)

        for record in monitoringList:
            if record[1] == "SQL" and record[4] == "Active":

                print("Execution started for :: " + record[0] + " Frequency :: "+  record[5] + " Execution Time :: "+  str(record[6]) + " Execution Days :: "+ record[7])

                if alertExecution(record[5], record[6], record[7]) == True:
                    execute_athena_query(record[0], record[2], record[3], queryOutPutS3Bucket, retryCount)
                    print("Execution stoped :: " + record[0] )
    except Exception as exception:
        print("lambda_handler :: " + str(exception))