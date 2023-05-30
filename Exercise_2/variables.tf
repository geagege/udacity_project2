# TODO: Define the variable for aws_region
variable "region" {
  default = "us-east-1"
}
variable "lambda_runtime" {
  default = "python3.9"
}
variable "lambda_handler" {
  default = "greet_lambda.lambda_handler"
}