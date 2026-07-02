PAZE Alert Catalogue - PAZE
=================================

Alert Catalogue
-------------
| Product | Corp. Area | Source (Device / App) | Alert | Alerting Tools | Threshold | Organizational Owner | Alert Owner | Who is notified | Escalation | Status | Type | Priority | How does this impact customers? | Runbook/Playbook Location? | Maintenance Mode availability to suspend alerting? (Y/N) |
|---------|------------|-----------------------|-------|----------------|-----------|----------------------|-------------|-----------------|------------|--------|------|----------|---------------------------------|----------------------------|---------------------------------------------------------|
| Paze    |            | PKS CPU Utilization is too high (CAT/PROD) | AppD Alerts>PagerDuty | "Hardware Resources|CPU|(%) Busy is: Warning: >75 Critical: >90" | Cloud/APIA | | TechOps | TechOps->Cloud/APIA Team | Active | PKS / TKGI | | |
| Paze    |            | Business Transaction Health (CAT/PROD) | AppD Alerts>PagerDuty | "If the average of all nodes meet Either (A and B) or (C and D and E) A) Average response time is >Baseline by 2 Baseline Standard Deviations B) Calls per minute is >100 C) Errors per Minute is >Baseline by 2 Baseline Standard Deviations D) Sum of Error per Minte is >5 E) Calls per Minute is >50" | Cloud/APIA | | TechOps | TechOps->Cloud/APIA Team | Active | PKS / TKGI | | |
| Paze    |            | F5 Device Failover or Failed F5 | BigIQ > WUG | Device Failure | F5 | | TechOps | TechOps->F5 | Active | | | |
| Paze    |            | EC2 Disk Usage | CloudWatch>TechOps Emails | "informational ( 85 ) warning ( 95 ) critical ( 99 )" | Delivery/Prod ENG | | TechOps | TechOps->Delivery->Cloud/Prod ENG | Active | | | |
| Paze    |            | Session Processor, Web Server and Messaging Server Availability | Sitemanager/TechOps Emails | Server State Changes (Start,Stop) | Delivery/Mesh | | TechOps | TechOps->Delivery->Mesh Prod ENG | Active | | | |
| Paze    |            | WebResponse Encryption: failed to encrypt payload: Failed to parse JWK (Wrong Client Assertion) X 10 Instances | Sitemanager/TechOps Emails | Sitemanager Logs | Delivery/Mesh | | TechOps | TechOps->Delivery->Mesh Prod ENG | Active | | | |
| Paze    |            | Batch File Processing | Splunk | Monitor when file arrives, when it processes and when response is sent | Delivery | | Delivery | Delivery | Active | | | |
| Paze    |            | Access to Prod/CAT Dynamo DB | Splunk / Delivery Emails | Splunk - KMS Crypto Ops on DDB by Unexpected Principal | Delivery | | Delivery | Delivery | Active | | | |
| Paze    |            | Application Error | Splunk>PagerDuty | | Delivery | | TechOps | TechOps->Delivery->Prod ENG | Active | Bulk Provisioning | | |
| Paze    |            | Kinesis Stream Availability | Splunk>PagerDuty | | Delivery/Cloud | | TechOps | TechOps->Delivery->Cloud/Prod ENG | Active | Kinesis Stream | | |
| Paze    |            | 3rd Party Connectivity (Syniverse,Nudetect) | Splunk>PagerDuty | | Delivery/Mesh | | TechOps | TechOps->Delivery->Mesh Prod ENG | Active | 3rd Party Conn | | |
| Paze    |            | Website Availability: https://mywallet-management.wallet.cat.earlywarning.io https://mywallet-management-east.wallet.cat.earlywarning.io https://mywallet-management-west.wallet.cat.earlywarning.io https://mywallet.paze.com https://mywallet-east.paze.com/ https://mywallet-west.paze.com/ | Thousand Eyes > PagerDuty | Ping URLS and 200 Responses | TechOps | | TechOps | TechOps->Delivery->Mesh/Prod ENG | Active | URL Availability | | |

