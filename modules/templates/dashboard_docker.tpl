{
  "widgets": [
    {
      "type": "text",
      "x": 0,
      "y": 0,
      "width": 24,
      "height": 1,
      "properties": {
        "markdown": "### EC2 and Docker Containers Monitoring Dashboard"
      }
    },
    {
      "type": "metric",
      "x": 0,
      "y": 1,
      "width": 6,
      "height": 6,
      "properties": {
        "view": "timeSeries",
        "stacked": false,
        "metrics": [
          [ { "expression": "SEARCH('{DockerStats,InstanceId,ContainerId,ContainerName} MetricName=\"Memory\" ContainerName=\"${addon_services}\"', 'Average', 300)" } ],
          [ { "expression": "SEARCH('{DockerStats,InstanceId,ContainerId,ContainerName} MetricName=\"CPU\" ContainerName=\"${addon_services}\"', 'Average', 300)" } ],
          [ { "expression": "SEARCH('{DockerStats,InstanceId,ContainerId,ContainerName} MetricName=\"Ports\" ContainerName=\"${addon_services}\"', 'Average', 300)" } ]
        ],
        "region": "${region}",
        "title": "Addon Services Metrics"
      }
    },
    {
      "type": "metric",
      "x": 6,
      "y": 1,
      "width": 6,
      "height": 6,
      "properties": {
        "view": "timeSeries",
        "stacked": false,
        "metrics": [
          [ { "expression": "SEARCH('{DockerStats,InstanceId,ContainerId,ContainerName} MetricName=\"Memory\" ContainerName=\"${session_processor}\"', 'Average', 300)" } ],
          [ { "expression": "SEARCH('{DockerStats,InstanceId,ContainerId,ContainerName} MetricName=\"CPU\" ContainerName=\"${session_processor}\"', 'Average', 300)" } ],
          [ { "expression": "SEARCH('{DockerStats,InstanceId,ContainerId,ContainerName} MetricName=\"Ports\" ContainerName=\"${session_processor}\"', 'Average', 300)" } ]
        ],
        "region": "${region}",
        "title": "Session Processor Metrics"
      }
    },
    {
      "type": "metric",
      "x": 12,
      "y": 1,
      "width": 6,
      "height": 6,
      "properties": {
        "view": "timeSeries",
        "stacked": false,
        "metrics": [
          [ { "expression": "SEARCH('{DockerStats,InstanceId,ContainerId,ContainerName} MetricName=\"Memory\" ContainerName=\"${web_proxy}\"', 'Average', 300)" } ],
          [ { "expression": "SEARCH('{DockerStats,InstanceId,ContainerId,ContainerName} MetricName=\"CPU\" ContainerName=\"${web_proxy}\"', 'Average', 300)" } ],
          [ { "expression": "SEARCH('{DockerStats,InstanceId,ContainerId,ContainerName} MetricName=\"Ports\" ContainerName=\"${web_proxy}\"', 'Average', 300)" } ]
        ],
        "region": "${region}",
        "title": "Web Proxy Metrics"
      }
    },
    {
      "type": "metric",
      "x": 18,
      "y": 1,
      "width": 6,
      "height": 6,
      "properties": {
        "view": "timeSeries",
        "stacked": false,
        "metrics": [
          [ { "expression": "SEARCH('{DockerStats,InstanceId,ContainerId,ContainerName} MetricName=\"Memory\" ContainerName=\"${site_manager}\"', 'Average', 300)" } ],
          [ { "expression": "SEARCH('{DockerStats,InstanceId,ContainerId,ContainerName} MetricName=\"CPU\" ContainerName=\"${site_manager}\"', 'Average', 300)" } ],
          [ { "expression": "SEARCH('{DockerStats,InstanceId,ContainerId,ContainerName} MetricName=\"Ports\" ContainerName=\"${site_manager}\"', 'Average', 300)" } ]
        ],
        "region": "${region}",
        "title": "Site Manager Metrics"
      }
    },
    {
      "height": 6,
      "width": 12,
      "y": 7,
      "x": 0,
      "type": "metric",
      "properties": {
        "view": "gauge",
        "stacked": false,
        "metrics": [
          [ { "expression": "SEARCH('{DockerStats,InstanceId,ContainerId,ContainerName} MetricName=\"CPU\" ContainerName=\"${addon_services}\"', 'Average', 300)" } ],
          [ { "expression": "SEARCH('{DockerStats,InstanceId,ContainerId,ContainerName} MetricName=\"CPU\" ContainerName=\"${session_processor}\"', 'Average', 300)" } ],
          [ { "expression": "SEARCH('{DockerStats,InstanceId,ContainerId,ContainerName} MetricName=\"CPU\" ContainerName=\"${web_proxy}\"', 'Average', 300)" } ],
          [ { "expression": "SEARCH('{DockerStats,InstanceId,ContainerId,ContainerName} MetricName=\"CPU\" ContainerName=\"${site_manager}\"', 'Average', 300)" } ]
        ],
        "region": "${region}",
        "title": "Overall CPU Utilization",
        "liveData": true,
        "yAxis": {
          "left": {
            "min": 0,
            "max": 100
          }
        }
      }
    },
    {
      "height": 6,
      "width": 12,
      "y": 7,
      "x": 12,
      "type": "metric",
      "properties": {
        "view": "pie",
        "stacked": false,
        "metrics": [
          [ { "expression": "SEARCH('{DockerStats,InstanceId,ContainerId,ContainerName} MetricName=\"Memory\" ContainerName=\"${addon_services}\"', 'Average', 300)" } ],
          [ { "expression": "SEARCH('{DockerStats,InstanceId,ContainerId,ContainerName} MetricName=\"Memory\" ContainerName=\"${session_processor}\"', 'Average', 300)" } ],
          [ { "expression": "SEARCH('{DockerStats,InstanceId,ContainerId,ContainerName} MetricName=\"Memory\" ContainerName=\"${web_proxy}\"', 'Average', 300)" } ],
          [ { "expression": "SEARCH('{DockerStats,InstanceId,ContainerId,ContainerName} MetricName=\"Memory\" ContainerName=\"${site_manager}\"', 'Average', 300)" } ]
        ],
        "region": "${region}",
        "title": "Memory Utilization Distribution"
      }
    },
    {
      "height": 6,
      "width": 24,
      "y": 13,
      "x": 0,
      "type": "log",
      "properties": {
        "query": "fields @timestamp, ContainerName, CPUUtilization, MemoryUtilization, InstanceId | sort @timestamp desc | limit 20",
        "region": "${region}",
        "title": "Recent Container Logs"
      }
    }
  ]
}
