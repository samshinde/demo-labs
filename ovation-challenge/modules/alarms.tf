locals {
  resource_prefix ="apialarm"
  fourRate_name = "${floor(var.fourRate_threshold * 100)}% 4xx errors over the last ${var.fourRate_evaluationPeriods} mins"
  fiveRate_name = "${floor(var.fiveRate_threshold * 100)}% 5xx errors over the last ${var.fiveRate_evaluationPeriods} mins"
}

# -----------------------------------------------------------------------------
# API Gateway 4XX Rate error Alarm
# -----------------------------------------------------------------------------
resource "aws_cloudwatch_metric_alarm" "fourRate" {
  for_each = var.resources

  alarm_name                = "${local.resource_prefix}-${each.key} | ${local.fourRate_name}"
  alarm_description         = "${local.resource_prefix}-${each.key} | ${local.fourRate_name}"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = var.fourRate_evaluationPeriods
  threshold                 = var.fourRate_threshold
  insufficient_data_actions = []

  treat_missing_data = "notBreaching"

  metric_query {
    id          = "errorRate"
    label       = "4XX Rate (%)"
    expression  = "error4xx / count"
    return_data = true
  }

  metric_query {
    id    = "count"
    label = "Count"

    metric {
      metric_name = "Count"
      namespace   = "AWS/ApiGateway"
      period      = "60"
      stat        = "Sum"
      unit        = "Count"

      dimensions = {
        ApiName  = var.api_name
        Resource = each.key
        Method   = each.value
        Stage    = var.api_stage
      }
    }

    return_data = false
  }

  metric_query {
    id    = "error4xx"
    label = "4XX Error"

    metric {
      metric_name = "4XXError"
      namespace   = "AWS/ApiGateway"
      period      = "60"
      stat        = "Sum"
      unit        = "Count"

      dimensions = {
        ApiName  = var.api_name
        Resource = each.key
        Method   = each.value
        Stage    = var.api_stage
      }
    }

    return_data = false
  }

  tags = {
    Name        = var.api_name
  }
}

# -----------------------------------------------------------------------------
# API Gateway 5XX Rate error Alarm
# -----------------------------------------------------------------------------
resource "aws_cloudwatch_metric_alarm" "fiveRate" {
  for_each = var.resources

  alarm_name                = "${local.resource_prefix}-${each.key} | ${local.fiveRate_name}"
  alarm_description         = "${local.resource_prefix}-${each.key} | ${local.fiveRate_name}"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = var.fiveRate_evaluationPeriods
  threshold                 = var.fiveRate_threshold
  insufficient_data_actions = []

  treat_missing_data = "notBreaching"

  metric_query {
    id          = "errorRate"
    label       = "5XX Rate (%)"
    expression  = "error5xx / count"
    return_data = true
  }

  metric_query {
    id    = "count"
    label = "Count"

    metric {
      metric_name = "Count"
      namespace   = "AWS/ApiGateway"
      period      = "60"
      stat        = "Sum"
      unit        = "Count"

      dimensions = {
        ApiName  = var.api_name
        Resource = each.key
        Method   = each.value
        Stage    = var.api_stage
      }
    }

    return_data = false
  }

  metric_query {
    id    = "error5xx"
    label = "5XX Error"

    metric {
      metric_name = "5XXError"
      namespace   = "AWS/ApiGateway"
      period      = "60"
      stat        = "Sum"
      unit        = "Count"

      dimensions = {
        ApiName  = var.api_name
        Resource = each.key
        Method   = each.value
        Stage    = var.api_stage
      }
    }

    return_data = false
  }

  tags = {
    Name        = var.api_name
  }
}