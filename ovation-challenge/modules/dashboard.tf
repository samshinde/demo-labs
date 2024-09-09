resource "aws_cloudwatch_dashboard" "api_dashboard" {
  dashboard_name = "ovation-api-dashboard"
  dashboard_body = <<EOF
{
  "widgets": [
    {
      "type": "metric",
      "x": 6,
      "y": 0,
      "width": 6,
      "height": 6,
      "properties": {
        "metrics": [
          ["AWS/ApiGateway", "Count", "ApiName", "${var.api_name}", { "stat": "Sum" }]
        ],
        "view": "timeSeries",
        "stacked": false,
        "title": "Ok (2xx)",
        "region": "ap-south-1",
        "period": 300
      }
    },
    {
      "type": "metric",
      "x": 12,
      "y": 0,
      "width": 6,
      "height": 6,
      "properties": {
        "metrics": [
          ["AWS/ApiGateway", "4XXError", "ApiName", "${var.api_name}", { "stat": "Sum" }]
        ],
        "view": "timeSeries",
        "stacked": false,
        "title": "Error (4xx)",
        "region": "ap-south-1",
        "period": 300
      }
    },
    {
      "type": "metric",
      "x": 0,
      "y": 6,
      "width": 6,
      "height": 6,
      "properties": {
        "metrics": [
          ["AWS/ApiGateway", "5XXError", "ApiName", "${var.api_name}", { "stat": "Sum" }]
        ],
        "view": "timeSeries",
        "stacked": false,
        "title": "Faults (5xx)",
        "region": "ap-south-1",
        "period": 300
      }
    },
    {
      "type": "metric",
      "x": 6,
      "y": 6,
      "width": 6,
      "height": 6,
      "properties": {
          "metrics": [
          ["AWS/ApiGateway", "Throttle", "ApiName", "${var.api_name}", { "stat": "Sum" }]
          ],
          "view": "timeSeries",
          "stacked": false,
          "title": "Throttle",
          "region": "ap-south-1",
          "period": 300
        }
    }
  ]
}
EOF
}