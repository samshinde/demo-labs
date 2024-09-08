resource "aws_cloudwatch_log_group" "api_gw_rest" {
  name = "/aws/api_gw/${var.api_gateway_name}-${random_string.random.id}"
  retention_in_days = var.log_retention
  depends_on = [random_string.random]
}

resource "aws_api_gateway_rest_api" "ovation_rest_api" {
  name = "ovation-rest-api"
  description = "ovation_rest_api"
  endpoint_configuration {
    types = ["EDGE"]
  }
}

resource "aws_api_gateway_deployment" "ovation_rest_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.ovation_rest_api.id
  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.ovation_rest_api.body))
  }
  lifecycle {
    create_before_destroy = true
  }
  depends_on = [
    aws_api_gateway_rest_api.ovation_rest_api,
    aws_api_gateway_integration.create_lambda_integration,
    aws_api_gateway_integration.read_lambda_integration,
    aws_api_gateway_integration.update_lambda_integration,
    aws_api_gateway_integration.delete_lambda_integration
  ]
}

resource "aws_api_gateway_stage" "ovation_rest_api_deployment_stage" {
  deployment_id = aws_api_gateway_deployment.ovation_rest_api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.ovation_rest_api.id
  stage_name    = "v1"

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw_rest.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
  depends_on = [
    aws_api_gateway_account.ovation_api,
    aws_api_gateway_deployment.ovation_rest_api_deployment
  ]
}

resource "aws_api_gateway_method_settings" "all" {
  rest_api_id = aws_api_gateway_rest_api.ovation_rest_api.id
  stage_name  = aws_api_gateway_stage.ovation_rest_api_deployment_stage.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true
    logging_level   = "INFO"
  }
  depends_on = [aws_api_gateway_stage.ovation_rest_api_deployment_stage]
}
