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



