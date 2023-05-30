terraform {
  backend "local" {
    path = ".terraform/terraform.state"
  }
}

provider "aws" {
  region = var.region
  profile = "udacity"
}

data "archive_file" "lambda_src" {
  type        = "zip"
  source_file = "greet_lambda.py"
  output_path = "lambda.zip"
}

data "aws_iam_policy_document" "lambda" {
  statement {
    sid    = ""
    effect = "Allow"
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "lambda" {
  name               = "udacity-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/AWSLambdaExecute"]
}

resource "aws_lambda_function" "lambda" {
  function_name = "udacity-terraform"
  environment {
    variables = {
      greeting = "Udacity environmen variable"
    }
  }
  role = aws_iam_role.lambda.arn
  filename = data.archive_file.lambda_src.output_path
  source_code_hash = data.archive_file.lambda_src.output_base64sha256
  handler = var.lambda_handler
  runtime = var.lambda_runtime
}