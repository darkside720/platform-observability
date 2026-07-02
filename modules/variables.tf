
variable "account_id" {
  description = "Account ID of the AWS environment"
  type        = string
}

variable "environment" {
  description = "AWS environment"
  type        = string
}

variable "region" {
  description = "Region where resource needs to be provisioned"
  type        = string
}

variable "category" {
  description = "Project"
  type        = string
}

variable "application" {
  description = "Sub-project, application"
  type        = string
}

variable "ticket" {
  type = string
}

variable "repo_url" {
  type = string
}

variable "created_by" {
  type = string
}

variable "created_on" {
  description = "Resource created date"
  type        = string
}

variable "expiry_date" {
  description = "Resource expiry date"
  type        = string
}

# Module parameters

variable "temp_sns_topic_paze_sre_alarms" {
  type = object({
    name         = string
    display_name = string
  })
  default = {
    name         = "temp_paze_sre_alarms"
    display_name = "PAZE SRE AWS Alert"
  }
}
variable "sns_topic_paze_sre_alarms" {
  type = object({
    name         = string
    display_name = string
  })
  default = {
    name         = "paze_sre_alarms"
    display_name = "Paze SRE Alarms"
  }
}

variable "sns_topic_paze_orchestration_team_endpoint" {
  type = object({
    name         = string
    display_name = string
  })
  default = {
    name         = "paze_orchestration_team_endpoint"
    display_name = "Paze Orchestration Team Alarms"
  }
}
variable "container_ids" {
  type = map(string)
  default = {
    site_manager      = "mesh_sitemanager"
    session_processor = "mesh_sessionprocessor"
    web_proxy         = "mesh_webproxy"
    addon_services    = "mesh_addonsvc"
  }
}

variable "instance_ids" {
  description = "Map of container names to their instance IDs"
  type        = map(string)
  default = {
    site_manager      = "mesh_sitemanager"
    session_processor = "mesh_sessionprocessor"
    web_proxy         = "mesh_webproxy"
    addon_services    = "mesh_addonsvc"
  }
}

variable "protocol" {
  type = string
  default = "email"
}

variable "endpoint" {
  type = string
  default = ""
}

variable "sns_subscription_paze_orchestration_team_endpoint" {
  description = "Configuration for the SNS subscription"
  type = object({
    protocol = string
    endpoint = string
  })
  default = {
    protocol = "email"
    endpoint = "paze-orchestration-team@earlywarning.com"
  }
}

variable "sns_subscription_paze_sre_alarms" {
  description = "Configuration for the SNS subscription"
  type = object({
    protocol = string
    endpoint = string
  })
  default = {
    protocol = "email"
    endpoint = "wallet_pd_alerting@earlywarning.pagerduty.com"
  }
}
variable "temp_sns_subscription_paze_sre_alarms" {
  description = "Configuration for the SNS subscription"
  type = object({
    protocol = string
    endpoint = string
  })
  default = {
    protocol = "email"
    endpoint = "paze-sre@earlywarning.com"
  }
}

variable "extra_tags" {
  description = "Extra tags to be added to the resources"
  type        = map(string)
  default     = {}
}

################################################################################
# Queue
################################################################################

variable "content_based_deduplication" {
  description = "Enables content-based deduplication for FIFO queues"
  type        = bool
  default     = null
}

variable "deduplication_scope" {
  description = "Specifies whether message deduplication occurs at the message group or queue level"
  type        = string
  default     = null
}

variable "delay_seconds" {
  description = "The time in seconds that the delivery of all messages in the queue will be delayed. An integer from 0 to 900 (15 minutes)"
  type        = number
  default     = null
}

variable "fifo_queue" {
  description = "Boolean designating a FIFO queue"
  type        = bool
  default     = false
}

variable "fifo_throughput_limit" {
  description = "Specifies whether the FIFO queue throughput quota applies to the entire queue or per message group"
  type        = string
  default     = null
}

variable "max_message_size" {
  description = "The limit of how many bytes a message can contain before Amazon SQS rejects it. An integer from 1024 bytes (1 KiB) up to 262144 bytes (256 KiB)"
  type        = number
  default     = null
}

variable "message_retention_seconds" {
  description = "The number of seconds Amazon SQS retains a message. Integer representing seconds, from 60 (1 minute) to 1209600 (14 days)"
  type        = number
  default     = null
}

variable "name" {
  description = "This is the human-readable name of the queue. If omitted, Terraform will assign a random name"
  type        = string
  default     = null
}

variable "use_name_prefix" {
  description = "Determines whether `name` is used as a prefix"
  type        = bool
  default     = false
}

################################################################################
# S3 Bucket - SRE Operational Bucket
################################################################################

variable "s3_sre_operational_bucket" {
  default = null
  type = object({
    name       = string
    versioning = bool
    kms = object({
      deletion_window_in_days = number
      multi_region            = bool
      alias                   = string
    })
    lifecycle_configuration = object({
      transition_standard_ia_days = number
      transition_glacier_days     = number
      expiration_days             = number
    })
    cloudfront_oai_id     = string
    management_account_id = number
  })
}


variable "cloudwatch_event_iam_sre_role" {
  type = object({
    name                  = string
    description           = string
    iam_policy_s3_keys    = list(string)
    assume_role_json_file = string
  })

  default = null
}

################################################################################
# S3 Bucket - Query Results
################################################################################

variable "s3_duplicate_wallet_query_results_bucket" {
  default = null
  type = object({
    name       = string
    versioning = bool
    kms = object({
      deletion_window_in_days = number
      multi_region            = bool
      alias                   = string
    })
    lifecycle_configuration = object({
      transition_standard_ia_days = number
      transition_glacier_days     = number
      expiration_days             = number
    })
    cloudfront_oai_id     = string
    management_account_id = number
  })
}

################################################################################
# Lambda - Lambda to monitor CouldWatch logs
################################################################################

variable "logsmonitor_lambda" {
  description = "lambda for forwarding observability verification logs to splunk"
  type = object({
    name                  = string
    description           = string
    runtime               = string
    handler               = string
    #filename              = string
    subnet_name           = string
    memory                = number
    timeout               = string
    security_groups       = list(string)
    environment_variables = map(string)
    log_group = object({
      name              = string
      retention_in_days = number
      skip_destroy      = bool
      kms_key_id        = string
    })
    role = object({
      name                   = string
      description            = string
      iam_policy_s3_keys     = list(string)
      assume_role_json_file  = string
      additional_policy_arns = optional(list(string))
    })
  })
  default = null
}

################################################################################
# Lambda Subscriptions
################################################################################

variable "logsmonitor_lambdaoutput_subscriptions" {
  description = "Set up lambda subscriptions for observability check lambda output logs"
  type = object({
    name            = string
    role_arn        = string
    log_group_name  = string
    filter_pattern  = string
    # destination_arn = string
    distribution    = string
  })
  default = null
}

################################################################################
# Lambda - to connect athena database and execute the SQL
################################################################################

variable "observability_check_lambda" {
  description = "lambda for to verify observability by connecting database "
  type = object({
    name                  = string
    description           = string
    runtime               = string
    handler               = string
    #filename              = string
    subnet_name           = string
    memory                = number
    timeout               = string
    security_groups       = list(string)
    environment_variables = map(string)
    log_group = object({
      name              = string
      retention_in_days = number
      skip_destroy      = bool
      kms_key_id        = string
    })
    role = object({
      name                   = string
      description            = string
      iam_policy_s3_keys     = list(string)
      assume_role_json_file  = string
      additional_policy_arns = optional(list(string))
    })
  })
  default = null
}


variable "description" {
  description = "string"
  type        = map(string)
  default     = {}
}

variable "eventbridge-scheduler-sre" {
  type = object({
    name                         = string
    schedule_expression          = string
    schedule_expression_timezone = optional(string)
    flexible_time_window         = object({
      mode = string
    })
  })
  default = null
} 

# Event Bridge IAM Role for Dashboard Updater Lambda
variable "dashboard_updater_event_bridge_scheduler_role" {
  type = object({
    name                  = string
    description           = string
    iam_policy_s3_keys    = list(string)
    assume_role_json_file = string
  })
  default = null
}

# Event Bridge Scheduler for Dashboard Updater Lambda
variable "dashboard_updater_event_bridge_scheduler" {
  type = object({
    name                         = string
    schedule_expression          = string
    schedule_expression_timezone = optional(string)
    flexible_time_window         = object({
      mode = string
    })
  })
  default = null
}

variable "dashboard_updater_lambda" {
  type = object({
    name                  = string
    description           = string
    runtime               = string
    handler               = string
    timeout               = number
    memory                = number
    subnet_name           = string
    security_groups       = list(string)
    environment_variables = map(string)
    log_group = object({
      name              = string
      retention_in_days = number
      skip_destroy      = bool
      kms_key_id        = string
    })
    role = object({
      name                   = string
      description            = string
      iam_policy_s3_keys     = list(string)
      assume_role_json_file  = string
      additional_policy_arns = optional(list(string))
    })
  })
  default = null
}

variable "severity" {
  description = "string"
  type        = map(string)
  default = {}
}

variable "dynamodb_table_names" {
  type    = map(string)
  default = {}
}

# variable "ddb_sre_sampletest" {
#   description = "Configuration for the DynamoDB table"
#   type = object({
#     create                   = bool
#     name                     = string
#     hash_key                 = string
#     hash_key_type            = string
#     range_key                = string
#     range_key_type           = string
#     # additional_attributes    = list(map(string))
#     global_secondary_indexes = list(map(string))
#     stream_enabled           = bool
#     stream_view_type         = string
#     ttl_enabled              = bool
#     ttl_attribute_name       = string
#     read_capacity            = number
#     write_capacity           = number
#     billing_mode             = string
#   })
# }

####################  Data Quality Monitoring CIs start ####################

variable "data_quality_cloudwatch_event_bridge_scheduler_role" {
  type = object({
    name                  = string
    description           = string
    iam_policy_s3_keys    = list(string)
    assume_role_json_file = string
  })

  default = null
}

variable "data_quality_event_bridge_scheduler" {
  type = object({
    name                         = string
    schedule_expression          = string
    schedule_expression_timezone = optional(string)
    flexible_time_window         = object({
      mode = string
    })
  })
  default = null
} 

variable "data_quality_lambda" {
  description = "lambda for verifying Analytics data quality"
  type = object({
    name                  = string
    description           = string
    runtime               = string
    handler               = string
    #filename              = string
    subnet_name           = string
    memory                = number
    timeout               = string
    security_groups       = list(string)
    environment_variables = map(string)
    log_group = object({
      name              = string
      retention_in_days = number
      skip_destroy      = bool
      kms_key_id        = string
    })
    role = object({
      name                   = string
      description            = string
      iam_policy_s3_keys     = list(string)
      assume_role_json_file  = string
      additional_policy_arns = optional(list(string))
    })
  })
  default = null
}


variable "data_quality_lambda_logs_subscriptions" {
  description = "data quality lambda logs subscriptions to splunk"
  type = object({
    name            = string
    role_arn        = string
    log_group_name  = string
    filter_pattern  = string
    # destination_arn = string
    distribution    = string
  })
  default = null
}

####################  Data Quality Monitoring CIs end ####################

####################  Athena ProcessedBytes Alert start ####################

variable "sre_cloudwatch_alert" {
  description = "sre cloudwatch alerts"
  type = map(object({
    name                     = string
    alarm_description        = string
    severity                 = string
    comparison_operator      = string
    evaluation_periods       = number
    metric_name              = string
    namespace                = string
    period                   = number
    unit                     = string
    statistic                = string
    threshold                = number
    dimensions               = map(string)
  }))
  default = {}
}


####################  Athena ProcessedBytes Alert start ####################