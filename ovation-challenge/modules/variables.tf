variable "aws_region" {
  description = "AWS region name"
  type = string
  default = "ap-south-1"
}

variable "aws_profile" {
  description = "AWS region name"
  type = string
  default = "default"
}

variable "lambda_name" {
  description = "Lambda name"
  type = string
  default = "api_logs"
}

variable "lambda_runtime" {
  description = "Lambda runtime"
  type = string
  default = "nodejs18.x"
}

variable "s3_bucket_prefix" {
  description = "s3_bucket_prefix name"
  type = string
  default = "api"
}

variable "dynamodb_table" {
  description = "DynamoDB table"
  type = string
  default = "lambda-dynamodb"
}

variable "lambda_log_retention" {
  description = "Lambda log retention"
  type = string
  default = "1"
}

variable "api_gateway_name" {
  description = "api_gateway name"
  type = string
  default = "ovation"
}

variable "log_retention" {
  description = "Log retention"
  type = string
  default = "1"
}

variable "burst_limit" {
  description = "burst_limit"
  type = string
  default = "100"
}

variable "rate_limit" {
  description = "rate_limit"
  type = string
  default = "50"
}

variable "quota_limit" {
  description = "quota_limit"
  type = string
  default = "1000"
}

variable "quota_period" {
  description = "quota_period"
  type = string
  default = "DAY"
}

variable "email_address" {
  description = "email_address"
  type = string
  default = "samshinde23290@gmail.com"
}

# -----------------------------------------------------------------------------
# Variables: API Gateway
# -----------------------------------------------------------------------------

variable "api_name" {
  description = "API Gateway Name"
  type        = string
  default     = "ovation-rest-api"
}

variable "api_stage" {
  description = "API Gateway stage"
  type        = string
  default     = "v1"
}

variable "resources" {
  description = "Methods that have Cloudwatch alarms enabled"
  type        = map
  default     = {
    "/create" = "POST",
    "/read"   = "GET",
    "/update" = "PUT",
    "/delete" = "DELETE",
  }
}

variable "fourRate_threshold" {
  description = "Percentage of errors that will trigger an alert"
  default     = 0.02
  type        = number
}

variable "fourRate_evaluationPeriods" {
  description = "How many periods are evaluated before the alarm is triggered"
  default     = 5
  type        = number
}

variable "fiveRate_threshold" {
  description = "Percentage of errors that will trigger an alert"
  default     = 0.02
  type        = number
}

variable "fiveRate_evaluationPeriods" {
  description = "How many periods are evaluated before the alarm is triggered"
  default     = 5
  type        = number
}