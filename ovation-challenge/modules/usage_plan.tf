resource "aws_api_gateway_usage_plan" "ovation_api_usage_plan" {
  name         = "ovation_api_usage_plan"
  description  = "ovation_api_usage_plan"

  api_stages {
    api_id = aws_api_gateway_rest_api.ovation_rest_api.id
    stage  = aws_api_gateway_stage.ovation_rest_api_deployment_stage.stage_name
  }

  quota_settings {
    limit  = var.quota_limit
    period = var.quota_period
  }

  throttle_settings {
    burst_limit = var.burst_limit
    rate_limit  = var.rate_limit
  }

  depends_on = [aws_api_gateway_rest_api.ovation_rest_api, aws_api_gateway_stage.ovation_rest_api_deployment_stage]
}

resource "aws_api_gateway_api_key" "usage_plan_key" {
  name = "usage_plan_key"
}

resource "aws_api_gateway_usage_plan_key" "main" {
  key_id        = aws_api_gateway_api_key.usage_plan_key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.ovation_api_usage_plan.id
}