//A list of moved resources due to code refactoring
moved { 
  from = module.cloudwatch_event_iam_sre_role.aws_iam_policy.policy[0]                                                                                      
  to   = module.cloudwatch_event_iam_sre_role[0].aws_iam_policy.policy[0] 
}
moved { 
  from = module.cloudwatch_event_iam_sre_role.aws_iam_role.main                                                                                             
  to   = module.cloudwatch_event_iam_sre_role[0].aws_iam_role.main 
}
moved { 
  from = module.cloudwatch_event_iam_sre_role.aws_iam_role_policy_attachment.role_policy_attachment[0]                                                      
  to   = module.cloudwatch_event_iam_sre_role[0].aws_iam_role_policy_attachment.role_policy_attachment[0] 
}
moved { 
  from = module.eventbridge-scheduler-sre.aws_scheduler_schedule.main                                                                                       
  to   = module.eventbridge-scheduler-sre[0].aws_scheduler_schedule.main 
}
moved { 
  from = module.lambdalogs_lambda_log_group.aws_cloudwatch_log_group.main                                                                                   
  to   = module.lambdalogs_lambda_log_group[0].aws_cloudwatch_log_group.main 
}
moved { 
  from = module.logsmonitor_lambda.aws_lambda_function.main                                                                                                 
  to   = module.logsmonitor_lambda[0].aws_lambda_function.main 
}
moved { 
  from = module.logsmonitor_lambda.aws_lambda_permission.lambda_permission[0]                                                                               
  to   = module.logsmonitor_lambda[0].aws_lambda_permission.lambda_permission[0] 
}
moved { 
  from = module.logsmonitor_lambda_role.aws_iam_policy.policy[0]                                                                                            
  to   = module.logsmonitor_lambda_role[0].aws_iam_policy.policy[0] 
}
moved { 
  from = module.logsmonitor_lambda_role.aws_iam_role.main                                                                                                   
  to   = module.logsmonitor_lambda_role[0].aws_iam_role.main 
}
moved { 
  from = module.logsmonitor_lambda_role.aws_iam_role_policy_attachment.additional_policies_attachment[0]                                                    
  to   = module.logsmonitor_lambda_role[0].aws_iam_role_policy_attachment.additional_policies_attachment[0] 
}
moved { 
  from = module.logsmonitor_lambda_role.aws_iam_role_policy_attachment.role_policy_attachment[0]                                                            
  to   = module.logsmonitor_lambda_role[0].aws_iam_role_policy_attachment.role_policy_attachment[0] 
}
moved { 
  from = module.logsmonitor_lambdaoutput_subscriptions.aws_cloudwatch_log_subscription_filter.main                                                          
  to   = module.logsmonitor_lambdaoutput_subscriptions[0].aws_cloudwatch_log_subscription_filter.main 
}
moved { 
  from = module.observability_check_lambda.aws_lambda_function.main                                                                                         
  to   = module.observability_check_lambda[0].aws_lambda_function.main 
}
moved { 
  from = module.observability_check_lambda.aws_lambda_permission.lambda_permission[0]                                                                       
  to   = module.observability_check_lambda[0].aws_lambda_permission.lambda_permission[0] 
}
moved { 
  from = module.observability_check_lambda_log_group.aws_cloudwatch_log_group.main                                                                          
  to   = module.observability_check_lambda_log_group[0].aws_cloudwatch_log_group.main 
}
moved { 
  from = module.observability_check_lambda_role.aws_iam_policy.policy[0]                                                                                    
  to   = module.observability_check_lambda_role[0].aws_iam_policy.policy[0] 
}
moved { 
  from = module.observability_check_lambda_role.aws_iam_role.main                                                                                           
  to   = module.observability_check_lambda_role[0].aws_iam_role.main 
}
moved { 
  from = module.observability_check_lambda_role.aws_iam_role_policy_attachment.additional_policies_attachment[0]                                            
  to   = module.observability_check_lambda_role[0].aws_iam_role_policy_attachment.additional_policies_attachment[0] 
}
moved { 
  from = module.observability_check_lambda_role.aws_iam_role_policy_attachment.role_policy_attachment[0]                                                    
  to   = module.observability_check_lambda_role[0].aws_iam_role_policy_attachment.role_policy_attachment[0] 
}
moved { 
  from = module.s3_duplicate_wallet_query_results_bucket.aws_s3_bucket_lifecycle_configuration.s3_bucket_lifecycle_configuration[0]                         
  to   = module.s3_duplicate_wallet_query_results_bucket[0].aws_s3_bucket_lifecycle_configuration.s3_bucket_lifecycle_configuration[0] 
}
moved { 
  from = module.s3_duplicate_wallet_query_results_bucket.aws_s3_bucket_logging.s3_bucket_logging                                                            
  to   = module.s3_duplicate_wallet_query_results_bucket[0].aws_s3_bucket_logging.s3_bucket_logging 
}
moved { 
  from = module.s3_duplicate_wallet_query_results_bucket.aws_s3_bucket_ownership_controls.s3_bucket_ownership_enforced                                      
  to   = module.s3_duplicate_wallet_query_results_bucket[0].aws_s3_bucket_ownership_controls.s3_bucket_ownership_enforced 
}
moved { 
  from = module.s3_duplicate_wallet_query_results_bucket.aws_s3_bucket_policy.bucket_policy_non_cloudfront[0]                                               
  to   = module.s3_duplicate_wallet_query_results_bucket[0].aws_s3_bucket_policy.bucket_policy_non_cloudfront[0] 
}
moved { 
  from = module.s3_duplicate_wallet_query_results_bucket.aws_s3_bucket_public_access_block.s3_bucket_public_access_block                                    
  to   = module.s3_duplicate_wallet_query_results_bucket[0].aws_s3_bucket_public_access_block.s3_bucket_public_access_block 
}
moved { 
  from = module.s3_duplicate_wallet_query_results_bucket.aws_s3_bucket_server_side_encryption_configuration.s3_bucket_server_side_encryption_configuration  
  to   = module.s3_duplicate_wallet_query_results_bucket[0].aws_s3_bucket_server_side_encryption_configuration.s3_bucket_server_side_encryption_configuration 
}
moved { 
  from = module.s3_duplicate_wallet_query_results_bucket.aws_s3_bucket_versioning.bucket_versioning[0]                                                      
  to   = module.s3_duplicate_wallet_query_results_bucket[0].aws_s3_bucket_versioning.bucket_versioning[0] 
}
moved { 
  from = module.s3_duplicate_wallet_query_results_bucket_key.aws_kms_alias.kms_alias[0]                                                                     
  to   = module.s3_duplicate_wallet_query_results_bucket_key[0].aws_kms_alias.kms_alias[0]                                                    
}
moved { 
  from = module.s3_duplicate_wallet_query_results_bucket_key.aws_kms_key.kms_key                                                                            
  to   = module.s3_duplicate_wallet_query_results_bucket_key[0].aws_kms_key.kms_key 
}
moved { 
  from = module.s3_sre_operational_bucket.aws_s3_bucket_lifecycle_configuration.s3_bucket_lifecycle_configuration[0]                                        
  to   = module.s3_sre_operational_bucket[0].aws_s3_bucket_lifecycle_configuration.s3_bucket_lifecycle_configuration[0] 
}
moved { 
  from = module.s3_sre_operational_bucket.aws_s3_bucket_logging.s3_bucket_logging                                                                           
  to   = module.s3_sre_operational_bucket[0].aws_s3_bucket_logging.s3_bucket_logging 
}
moved { 
  from = module.s3_sre_operational_bucket.aws_s3_bucket_ownership_controls.s3_bucket_ownership_enforced                                                     
  to   = module.s3_sre_operational_bucket[0].aws_s3_bucket_ownership_controls.s3_bucket_ownership_enforced 
}
moved { 
  from = module.s3_sre_operational_bucket.aws_s3_bucket_policy.bucket_policy_non_cloudfront[0]                                                              
  to   = module.s3_sre_operational_bucket[0].aws_s3_bucket_policy.bucket_policy_non_cloudfront[0] 
}
moved { 
  from = module.s3_sre_operational_bucket.aws_s3_bucket_public_access_block.s3_bucket_public_access_block                                                   
  to   = module.s3_sre_operational_bucket[0].aws_s3_bucket_public_access_block.s3_bucket_public_access_block 
}
moved { 
  from = module.s3_sre_operational_bucket.aws_s3_bucket_server_side_encryption_configuration.s3_bucket_server_side_encryption_configuration                 
  to   = module.s3_sre_operational_bucket[0].aws_s3_bucket_server_side_encryption_configuration.s3_bucket_server_side_encryption_configuration 
}
moved { 
  from = module.s3_sre_operational_bucket.aws_s3_bucket_versioning.bucket_versioning[0]                                                                     
  to   = module.s3_sre_operational_bucket[0].aws_s3_bucket_versioning.bucket_versioning[0] 
}
moved { 
  from = module.s3_sre_operational_bucket_key.aws_kms_alias.kms_alias[0]                                                                                    
  to   = module.s3_sre_operational_bucket_key[0].aws_kms_alias.kms_alias[0] 
}
moved { 
  from = module.s3_sre_operational_bucket_key.aws_kms_key.kms_key                                                                                           
  to   = module.s3_sre_operational_bucket_key[0].aws_kms_key.kms_key 
}
moved {
  from = module.s3_sre_operational_bucket.aws_s3_bucket.s3_bucket
  to   = module.s3_sre_operational_bucket[0].aws_s3_bucket.s3_bucket
}
moved {
  from = module.s3_duplicate_wallet_query_results_bucket.aws_s3_bucket.s3_bucket
  to   = module.s3_duplicate_wallet_query_results_bucket[0].aws_s3_bucket.s3_bucket
}