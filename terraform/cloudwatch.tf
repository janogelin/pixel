resource "aws_cloudwatch_dashboard" "pixel" {
  dashboard_name = "pixel-traffic-dashboard"
  dashboard_body = <<EOF
{
  "widgets": [
    {
      "type": "metric",
      "x": 0,
      "y": 0,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          [ "AWS/EC2", "CPUUtilization", "AutoScalingGroupName", "pixel-asg" ]
        ],
        "period": 300,
        "stat": "Average",
        "region": "${var.aws_region}",
        "title": "Pixel Server CPU Utilization"
      }
    }
  ]
}
EOF
}

# Add CloudWatch alarms for CPU, memory, network, consumer lag, and latency
# Add log group resources for application and infrastructure logs 