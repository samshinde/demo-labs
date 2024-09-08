resource "random_string" "random" {
  length           = 4
  special          = false
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket_prefix = var.s3_bucket_prefix
  force_destroy = true
}

data "archive_file" "lambda_package" {
  type = "zip"
  source_file = "index.js"
  output_path = "index.zip"
}

resource "aws_s3_object" "this" {
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = "index.zip"
  source = data.archive_file.lambda_package.output_path
  etag = filemd5(data.archive_file.lambda_package.output_path)
}

resource "aws_cloudwatch_log_group" "lambda_logs" {
  name = "/aws/lambda/${var.lambda_name}-${random_string.random.id}"
  retention_in_days = var.lambda_log_retention
}

resource "aws_dynamodb_table" "lambda_table" {
  name           = var.dynamodb_table
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "year"
  range_key      = "email"

  attribute {
    name = "year"
    type = "N"
  }
  
  attribute {
    name = "email"
    type = "S"
  }
}

resource "aws_lambda_function" "create_lambda" {
  function_name = "CreateFunction"
  role = aws_iam_role.lambda_role.arn
  handler = "index.handler"
  runtime = var.lambda_runtime

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.this.key

  source_code_hash = data.archive_file.lambda_package.output_base64sha256
  environment {
    variables = {
      DDB_TABLE = var.dynamodb_table
    }
  }
  depends_on = [aws_cloudwatch_log_group.lambda_logs]
}

resource "aws_lambda_function" "read_lambda" {
  function_name = "ReadFunction"
  role = aws_iam_role.lambda_role.arn
  handler = "index.handler"
  runtime = var.lambda_runtime
  source_code_hash = data.archive_file.lambda_package.output_base64sha256

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.this.key
  environment {
    variables = {
      DDB_TABLE = var.dynamodb_table
    }
  }
  depends_on = [aws_cloudwatch_log_group.lambda_logs]
}

resource "aws_lambda_function" "update_lambda" {
  function_name = "UpdateFunction"
  role = aws_iam_role.lambda_role.arn
  handler = "index.handler"
  runtime = var.lambda_runtime
  source_code_hash = data.archive_file.lambda_package.output_base64sha256

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.this.key
  environment {
    variables = {
      DDB_TABLE = var.dynamodb_table
    }
  }
  depends_on = [aws_cloudwatch_log_group.lambda_logs]
}

resource "aws_lambda_function" "delete_lambda" {
  function_name = "DeleteFunction"
  role = aws_iam_role.lambda_role.arn
  handler = "index.handler"
  runtime = var.lambda_runtime
  source_code_hash = data.archive_file.lambda_package.output_base64sha256

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.this.key
  environment {
    variables = {
      DDB_TABLE = var.dynamodb_table
    }
  }
  depends_on = [aws_cloudwatch_log_group.lambda_logs]
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
    {
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }
  ]
})
}

resource "aws_iam_policy" "lambda_policy" {
  name = "lambda-policy"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "dynamodb:GetItem",
                "dynamodb:PutItem",
                "dynamodb:UpdateItem"
            ],
            "Resource": "arn:aws:dynamodb:*:*:table/${var.dynamodb_table}"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "lambda_role_policy" {
  policy_arn = aws_iam_policy.lambda_policy.arn
  role = aws_iam_role.lambda_role.name
}