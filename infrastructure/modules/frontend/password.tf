data "archive_file" "zip" {
  type        = "zip"
  source_file = "${path.module}/functions/basic-auth.js"
  output_path = "${path.module}/functions/basic-auth.zip"
}

resource "aws_lambda_function" "basic_auth" {
  count            = var.password_protection ? 1 : 0
  filename         = data.archive_file.zip.output_path
  function_name    = "${var.app_name}-protect-with-password"
  role             = aws_iam_role.password-protection-role[0].arn
  handler          = "basic-auth.handler"
  runtime          = "nodejs18.x"
  source_code_hash = data.archive_file.zip.output_base64sha256
  description      = "Protect CloudFront distributions with Basic Authentication"
  publish          = true
  provider         = aws.us_east_1
}

resource "aws_iam_role" "password-protection-role" {
  count = var.password_protection ? 1 : 0
  name  = "${var.app_name}-basic-auth-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = ["lambda.amazonaws.com", "edgelambda.amazonaws.com"]
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda" {
  count = var.password_protection ? 1 : 0
  name  = "${var.app_name}-basic-auth-policy"
  role  = aws_iam_role.password-protection-role[0].id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

# TODO: Why
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}
