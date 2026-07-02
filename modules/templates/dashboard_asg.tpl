{
    "widgets": [
        {
            "height": 6,
            "width": 6,
            "y": 0,
            "x": 0,
            "type": "metric",
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/EC2", "MetadataNoToken", "AutoScalingGroupName", "${addon_services}" ],
                    [ ".", "StatusCheckFailed_System", ".", "." ],
                    [ ".", "DiskWriteOps", ".", "." ],
                    [ ".", "NetworkPacketsIn", ".", "." ],
                    [ ".", "CPUUtilization", ".", "." ],
                    [ ".", "DiskReadOps", ".", "." ],
                    [ ".", "EBSWriteOps", ".", "." ],
                    [ ".", "NetworkIn", ".", "." ],
                    [ ".", "StatusCheckFailed", ".", "." ],
                    [ ".", "EBSIOBalance%", ".", "." ],
                    [ ".", "DiskReadBytes", ".", "." ],
                    [ ".", "EBSReadBytes", ".", "." ],
                    [ ".", "EBSByteBalance%", ".", "." ],
                    [ ".", "StatusCheckFailed_Instance", ".", "." ],
                    [ ".", "EBSReadOps", ".", "." ],
                    [ ".", "NetworkPacketsOut", ".", "." ],
                    [ ".", "NetworkOut", ".", "." ],
                    [ ".", "EBSWriteBytes", ".", "." ],
                    [ ".", "DiskWriteBytes", ".", "." ]
                ],
                "region": "${region}",
                "title": "${addon_services}"
            }
        },
        {
            "height": 6,
            "width": 6,
            "y": 0,
            "x": 6,
            "type": "metric",
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/EC2", "StatusCheckFailed", "AutoScalingGroupName", "${session_processor}" ],
                    [ ".", "EBSReadBytes", ".", "." ],
                    [ ".", "EBSReadOps", ".", "." ],
                    [ ".", "CPUUtilization", ".", "." ],
                    [ ".", "DiskWriteOps", ".", "." ],
                    [ ".", "NetworkPacketsIn", ".", "." ],
                    [ ".", "EBSWriteOps", ".", "." ],
                    [ ".", "MetadataNoToken", ".", "." ],
                    [ ".", "DiskReadBytes", ".", "." ],
                    [ ".", "EBSIOBalance%", ".", "." ],
                    [ ".", "DiskWriteBytes", ".", "." ],
                    [ ".", "EBSByteBalance%", ".", "." ],
                    [ ".", "DiskReadOps", ".", "." ],
                    [ ".", "EBSWriteBytes", ".", "." ],
                    [ ".", "NetworkPacketsOut", ".", "." ],
                    [ ".", "NetworkOut", ".", "." ],
                    [ ".", "NetworkIn", ".", "." ],
                    [ ".", "StatusCheckFailed_Instance", ".", "." ],
                    [ ".", "StatusCheckFailed_System", ".", "." ]
                ],
                "region": "${region}",
                "title": "${session_processor}"
            }
        },
        {
            "height": 6,
            "width": 6,
            "y": 0,
            "x": 12,
            "type": "metric",
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/EC2", "DiskReadBytes", "AutoScalingGroupName", "${site_manager}" ],
                    [ ".", "NetworkOut", ".", "." ],
                    [ ".", "EBSWriteOps", ".", "." ],
                    [ ".", "EBSWriteBytes", ".", "." ],
                    [ ".", "EBSReadOps", ".", "." ],
                    [ ".", "DiskReadOps", ".", "." ],
                    [ ".", "DiskWriteBytes", ".", "." ],
                    [ ".", "EBSByteBalance%", ".", "." ],
                    [ ".", "StatusCheckFailed", ".", "." ],
                    [ ".", "DiskWriteOps", ".", "." ],
                    [ ".", "MetadataNoToken", ".", "." ],
                    [ ".", "NetworkPacketsIn", ".", "." ],
                    [ ".", "StatusCheckFailed_System", ".", "." ],
                    [ ".", "StatusCheckFailed_Instance", ".", "." ],
                    [ ".", "NetworkIn", ".", "." ],
                    [ ".", "CPUUtilization", ".", "." ],
                    [ ".", "EBSReadBytes", ".", "." ],
                    [ ".", "EBSIOBalance%", ".", "." ],
                    [ ".", "NetworkPacketsOut", ".", "." ]
                ],
                "region": "${region}",
                "title": "${site_manager}"
            }
        },
        {
            "height": 6,
            "width": 6,
            "y": 0,
            "x": 18,
            "type": "metric",
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/EC2", "EBSReadOps", "AutoScalingGroupName", "${web_proxy}" ],
                    [ ".", "EBSWriteBytes", ".", "." ],
                    [ ".", "NetworkOut", ".", "." ],
                    [ ".", "CPUUtilization", ".", "." ],
                    [ ".", "DiskWriteOps", ".", "." ],
                    [ ".", "NetworkPacketsIn", ".", "." ],
                    [ ".", "EBSIOBalance%", ".", "." ],
                    [ ".", "StatusCheckFailed_Instance", ".", "." ],
                    [ ".", "DiskReadOps", ".", "." ],
                    [ ".", "StatusCheckFailed_System", ".", "." ],
                    [ ".", "EBSWriteOps", ".", "." ],
                    [ ".", "EBSByteBalance%", ".", "." ],
                    [ ".", "DiskWriteBytes", ".", "." ],
                    [ ".", "NetworkPacketsOut", ".", "." ],
                    [ ".", "StatusCheckFailed", ".", "." ],
                    [ ".", "EBSReadBytes", ".", "." ],
                    [ ".", "MetadataNoToken", ".", "." ],
                    [ ".", "DiskReadBytes", ".", "." ],
                    [ ".", "NetworkIn", ".", "." ]
                ],
                "region": "${region}",
                "title": "${web_proxy}"
            }
        },
        {
            "height": 9,
            "width": 12,
            "y": 6,
            "x": 12,
            "type": "metric",
            "properties": {
                "view": "gauge",
                "stacked": false,
                "metrics": [
                    [ "AWS/EC2", "CPUUtilization", "AutoScalingGroupName", "${web_proxy}" ],
                    [ "AWS/EC2", "CPUUtilization", "AutoScalingGroupName", "${site_manager}" ],
                    [ "AWS/EC2", "CPUUtilization", "AutoScalingGroupName", "${session_processor}" ],
                    [ "AWS/EC2", "CPUUtilization", "AutoScalingGroupName", "${addon_services}" ]
                ],
                "region": "${region}",
                "title": "CPU_Utilization",
                "liveData": true,
                "yAxis": {
                    "left": {
                        "min": 2,
                        "max": 100
                    }
                }
            }
        },
        {
            "height": 9,
            "width": 12,
            "y": 6,
            "x": 0,
            "type": "metric",
            "properties": {
                "sparkline": true,
                "view": "singleValue",
                "stacked": false,
                "metrics": [
                    [ "CWAgent", "disk_used_percent", "AutoScalingGroupName", "${addon_services}" ],
                    [ "...", "${session_processor}" ],
                    [ "...", "${site_manager}" ],
                    [ "...", "${web_proxy}" ]
                ],
                "region": "${region}",
                "title": "disk_used_percent"
            }
        },
        {
            "height": 9,
            "width": 12,
            "y": 15,
            "x": 0,
            "type": "metric",
            "properties": {
                "sparkline": true,
                "view": "singleValue",
                "stacked": false,
                "metrics": [
                    [ "CWAgent", "mem_used_percent", "AutoScalingGroupName", "${addon_services}" ],
                    [ "...", "${session_processor}" ],
                    [ "...", "${site_manager}" ],
                    [ "...", "${web_proxy}" ]
                ],
                "region": "${region}",
                "title": "mem_used_percent"
            }
        }
    ]
}