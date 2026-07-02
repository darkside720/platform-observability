{
  "widgets": [
    {
      "height": 1,
      "width": 24,
      "y": 0,
      "x": 0,
      "type": "text",
      "properties": {
        "markdown": "### DynamoDB & Kinesis Monitoring Dashboard"
      }
    },
    {
      "height": 6,
      "width": 24,
      "y": 1,
      "x": 0,
      "type": "metric",
      "properties": {
        "title": "DynamoDB Read Requests (ms)",
        "view": "timeSeries",
        "stacked": false,
        "region": "${region}",
        "stat": "Average",
        "period": 60,
        "metrics": [
          %{ for table_name in jsondecode(dynamodb_table_names) ~}
            [ "AWS/DynamoDB", "SuccessfulRequestLatency", "TableName", "${table_name}", "Operation", "Scan", { "stat": "Average", "region": "${region}" } ],
            [ "AWS/DynamoDB", "SuccessfulRequestLatency", "TableName", "${table_name}", "Operation", "GetItem", { "stat": "Average", "region": "${region}" } ]
            %{ if table_name != jsondecode(dynamodb_table_names)[length(jsondecode(dynamodb_table_names)) - 1] ~},%{ endif ~}
          %{ endfor ~}
        ]
      }
    },
    {
      "height": 6,
      "width": 12,
      "y": 7,
      "x": 0,
      "type": "metric",
      "properties": {
        "title": "DynamoDB Latency (ms) by Operation",
        "view": "timeSeries",
        "stacked": false,
        "region": "${region}",
        "period": 300,
        "metrics": [
          %{ for table_name in jsondecode(dynamodb_table_names) ~}
            [ "AWS/DynamoDB", "SuccessfulRequestLatency", "TableName", "${table_name}", "Operation", "Query", { "stat": "Average", "region": "${region}" } ],
            [ "AWS/DynamoDB", "SuccessfulRequestLatency", "TableName", "${table_name}", "Operation", "UpdateItem", { "stat": "Average", "region": "${region}" } ],
            [ "AWS/DynamoDB", "SuccessfulRequestLatency", "TableName", "${table_name}", "Operation", "PutItem", { "stat": "Average", "region": "${region}" } ],
            [ "AWS/DynamoDB", "SuccessfulRequestLatency", "TableName", "${table_name}", "Operation", "BatchWriteItem", { "stat": "Average", "region": "${region}" } ],
            [ "AWS/DynamoDB", "SuccessfulRequestLatency", "TableName", "${table_name}", "Operation", "DeleteItem", { "stat": "Average", "region": "${region}" } ]
            %{ if table_name != jsondecode(dynamodb_table_names)[length(jsondecode(dynamodb_table_names)) - 1] ~},%{ endif ~}
          %{ endfor ~}
        ]
      }
    },
    {
      "height": 6,
      "width": 12,
      "y": 7,
      "x": 12,
      "type": "metric",
      "properties": {
        "title": "Kinesis GetRecords Metrics",
        "view": "timeSeries",
        "stacked": false,
        "region": "${region}",
        "period": 300,
        "metrics": [
          %{ for stream_name in jsondecode(kinesis_stream_names) ~}
            [ "AWS/Kinesis", "GetRecords.Bytes", "StreamName", "${stream_name}", { "stat": "Sum", "region": "${region}" } ],
            [ "AWS/Kinesis", "GetRecords.IteratorAgeMilliseconds", "StreamName", "${stream_name}", { "stat": "Maximum", "region": "${region}" } ],
            [ "AWS/Kinesis", "GetRecords.Latency", "StreamName", "${stream_name}", { "stat": "Average", "region": "${region}" } ],
            [ "AWS/Kinesis", "GetRecords.Records", "StreamName", "${stream_name}", { "stat": "Sum", "region": "${region}" } ]
            %{ if stream_name != jsondecode(kinesis_stream_names)[length(jsondecode(kinesis_stream_names)) - 1] ~},%{ endif ~}
          %{ endfor ~}
        ]
      }
    },
    {
      "height": 6,
      "width": 12,
      "y": 13,
      "x": 0,
      "type": "metric",
      "properties": {
        "title": "DynamoDB Provisioned Read Capacity",
        "view": "timeSeries",
        "stacked": false,
        "region": "${region}",
        "period": 300,
        "metrics": [
          %{ for table_name in jsondecode(dynamodb_table_names) ~}
            [ "AWS/DynamoDB", "ProvisionedReadCapacityUnits", "TableName", "${table_name}", { "stat": "Average", "region": "${region}" } ]
            %{ if table_name != jsondecode(dynamodb_table_names)[length(jsondecode(dynamodb_table_names)) - 1] ~},%{ endif ~}
          %{ endfor ~}
        ]
      }
    },
    {
      "height": 6,
      "width": 12,
      "y": 13,
      "x": 12,
      "type": "metric",
      "properties": {
        "title": "Kinesis PutRecords Metrics",
        "view": "timeSeries",
        "stacked": false,
        "region": "${region}",
        "period": 300,
        "metrics": [
          %{ for stream_name in jsondecode(kinesis_stream_names) ~}
            [ "AWS/Kinesis", "PutRecords.FailedRecords", "StreamName", "${stream_name}", { "stat": "Sum", "region": "${region}" } ],
            [ "AWS/Kinesis", "PutRecords.TotalRecords", "StreamName", "${stream_name}", { "stat": "Sum", "region": "${region}" } ],
            [ "AWS/Kinesis", "PutRecords.FailedRecords.Percent", "StreamName", "${stream_name}", { "stat": "Average", "region": "${region}" } ],
            [ "AWS/Kinesis", "WriteProvisionedThroughputExceeded", "StreamName", "${stream_name}", { "stat": "Average", "region": "${region}" } ],
            [ "AWS/Kinesis", "PutRecords.ThrottleRecords", "StreamName", "${stream_name}", { "stat": "Sum", "region": "${region}" } ]
            %{ if stream_name != jsondecode(kinesis_stream_names)[length(jsondecode(kinesis_stream_names)) - 1] ~},%{ endif ~}
          %{ endfor ~}
        ]
      }
    }
  ]
}
