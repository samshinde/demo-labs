resource "aws_api_gateway_resource" "delete_ovation_rest_api_root" {
  rest_api_id = aws_api_gateway_rest_api.ovation_rest_api.id
  parent_id = aws_api_gateway_rest_api.ovation_rest_api.root_resource_id
  path_part = "delete"
}

resource "aws_api_gateway_method" "delete_method" {
  rest_api_id = aws_api_gateway_rest_api.ovation_rest_api.id
  resource_id = aws_api_gateway_resource.delete_ovation_rest_api_root.id
  http_method = "DELETE"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "delete_method_response" {
  rest_api_id = aws_api_gateway_rest_api.ovation_rest_api.id
  resource_id = aws_api_gateway_resource.delete_ovation_rest_api_root.id
  http_method = aws_api_gateway_method.delete_method.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }

  depends_on = [
    aws_api_gateway_method.delete_method
  ]
}

resource "aws_api_gateway_integration" "delete_lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.ovation_rest_api.id
  resource_id = aws_api_gateway_resource.delete_ovation_rest_api_root.id
  http_method = aws_api_gateway_method.delete_method.http_method
  integration_http_method = "POST"
  type = "AWS"
  uri = aws_lambda_function.delete_lambda.invoke_arn
}

resource "aws_api_gateway_integration_response" "delete_lambda_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.ovation_rest_api.id
  resource_id = aws_api_gateway_resource.delete_ovation_rest_api_root.id
  http_method = aws_api_gateway_method.delete_method.http_method
  status_code = aws_api_gateway_method_response.delete_method_response.status_code

  # Transforms the backend JSON response to XML
  response_templates = {
    "application/json" = ""
  }

  depends_on = [
    aws_api_gateway_integration.delete_lambda_integration
  ]
}

resource "aws_lambda_permission" "delete_ovation_rest_api_permission" {
  statement_id = "AllowExecutionFromAPIGateway"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.delete_lambda.function_name
  principal = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.ovation_rest_api.execution_arn}/*/DELETE/delete"
  depends_on = [
    aws_api_gateway_integration.delete_lambda_integration
  ]
}