Splunk Query

Example

Description

 

Mesh Index

index=mesh-wallet-r <ewSID>

Services Index

index=k8s-containers-wallet-r <ewSID>

index=mesh-wallet-r 01905f39-2dda-4088-8dd1-bd7cf9aff0f7

index=k8s-containers-wallet-r 01905f39-2dda-4088-8dd1-bd7cf9aff0f7

index=mesh-wallet-r OR k8s-containers-wallet-r 01905f39-2dda-4088-8dd1-bd7cf9aff0f7

Basic query to search by ewSID

 

Mesh Index

index=mesh-wallet-r <walletID>

Services Index

index=k8s-containers-wallet-r <walletID>

index=mesh-wallet-r 01905f39-2dda-4088-8dd1-bd7cf9aff0f7

index=k8s-containers-wallet-r 01905f39-2dda-4088-8dd1-bd7cf9aff0f7

index=mesh-wallet-r OR k8s-containers-wallet-r01905f39-2dda-4088-8dd1-bd7cf9aff0f7

Basic query to search by WalletID

 

Mesh Index

index=mesh-wallet-r <api>

index=mesh-wallet-r "POST /issuer/notification"
index=mesh-wallet-r "POST /valta/v1/wallets"
index=mesh-wallet-r "POST /authenticateUser/v1"

index=mesh-wallet-r "POST /addcard/v1"

Basic query to search by mesh API

 

Mesh Index

index=mesh-wallet-r "Found a COMMON script [<common app name>]"

index=mesh-wallet-r "Found a COMMON script [GetIdentityKey]"

Query to search if the correct common app versions are loaded in env

 

Mesh Index

index=mesh-wallet-r <ewSID>"Script message: SESSION SUMMARY"

index=mesh-wallet-r 8b1f0224-1181-42a4-8ea7-c4f556b6ec60 "Script message: SESSION SUMMARY"

Query that quickly gives a summary of what happened to a transaction

 

Mesh Index - Prod

(index=mesh-wallet-r <ewSID> ("Starting step" walletcheckout) sourcetype=SessionProcessor (host="ip-10-174-*" OR host="ip-10-78-*"))

(index=mesh-wallet-r 8b1f0224-1181-42a4-8ea7-c4f556b6ec60 ("Starting step" walletcheckout) sourcetype=SessionProcessor (host="ip-10-174-*" OR host="ip-10-78-*"))

Query that lists all the steps executed for walletcheckout

 

Mesh Index - Prod

index=mesh-wallet-r "xaJwks: <kid>" AND xaAcc AND "xaStat: 7000"

| rex field=_raw "xaAcc: (?<xaAcc>[^\\\"]+)"

| dedup xaAcc

| stats count by xaAcc

index=mesh-wallet-r "xaJwks: 89DA4C182416A414BB75CBDD7A41A0BBB5C3FF03" AND xaAcc AND "xaStat: 7000"

| rex field=_raw "xaAcc: (?<xaAcc>[^\\\"]+)"

| dedup xaAcc

| stats count by xaAcc

Query that lists the bank using the kid value

 

Mesh Index - WFC IPs CAT
index=mesh-wallet-r /token AND POST (auth.wallet.cat.earlywarning.io) (151.151.* OR 159.45.* OR 161.231.* OR 168.175.* OR 170.13.* OR 121.244.* OR 123.63.* OR 2620:160* OR 2620:160*)

index=mesh-wallet-r /token AND POST (auth.wallet.cat.earlywarning.io) (151.151.* OR 159.45.* OR 161.231.* OR 168.175.* OR 170.13.* OR 121.244.* OR 123.63.* OR 2620:160* OR 2620:160*)

Query to filter /token endpoint based of issuer ip.

 

Mesh Index - Prod

(index=mesh-wallet-r statusCode="*" walletAuthPayLoad="*" (sipHttp="*" OR walletId="*") (tokenId="*" OR tokenReferenceId="*" OR walletAuthPayload="*" OR EventCode)) with OR ewSID

(index=mesh-wallet-r statusCode="*" walletAuthPayLoad="*" (sipHttp="*" OR walletId="*") (tokenId="*" OR tokenReferenceId="*" OR walletAuthPayload="*" OR EventCode)) with OR ewSID

Query to filter getwalletdetails and or tokenupdates

 

PAZE - Infra Health Status Checks

 

| inputlookup paze.csv
| eval host=Instance+"-"+InstanceID
| eval host=replace(host,"_","-")
| where Env="PROD" AND InstanceType="mesh-session_processor"
| join type=left host
    [ search index=mesh-wallet-r host="prodpaze-us*" SipPlugin "App SENT" sourcetype=SessionProcessor Root "sip:monitorsp" sipHttp="SIP/2.0 200 OK"
    | stats count as Success_count by host
    | table host, Success_count]
| eval Success_count=coalesce(Success_count,0)
| join type=left host [search index=mesh-wallet-r host="prodpaze-us*" SipPlugin "App SENT" sourcetype=SessionProcessor Root "sip:monitorsp" sipHttp!="SIP/2.0 200 OK"
    | stats count as Error_count by host
    | table host,Error_count
]
| eval Error_count=coalesce(Error_count,0)
| join type=left host [search index=mesh-wallet-r host="prodpaze-us*" SipPlugin "App RECEIVED" sourcetype=SessionProcessor Root "sip:monitorsp"
    | stats count as Request_count by host
    | table host,Request_count
]
| eval Request_count=coalesce(Request_count,0)
| eval Availability=round((100-(Error_count/Request_count)*100),2)
|table Zone,IP,Request_count,Success_count,Error_count,Availability
|sort Zone
