####################################################
# Create an SNS topic with a email subscription
####################################################
resource "aws_sns_topic" "topic" {
  name = "api_gateway_alerts"
}

resource "aws_sns_topic_subscription" "topic_email_subscription" {
  topic_arn = aws_sns_topic.topic.arn
  protocol  = "email"
  endpoint  = var.email_address
}