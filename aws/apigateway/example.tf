
provider "aws" {
  region = "ap-southeast-1"
}

data "aws_lambda_function" "example" {
    function_name = "example_lambda"
}

data "aws_lambda_function" "revoke" {
    function_name = "abclambda"
}

module "api_gateway" {
  source = "./modules"

  api_gateways = {
    chub-de = {
      api_name         = "chub-de"
      api_path         = "test"
      http_method      = "POST"
      endpoint_type    = "REGIONAL"
      lambda_invoke_arn = data.aws_lambda_function.example.invoke_arn
      authorization     = "AWS_IAM"
      stage_name       = "dev"
      api_key_required = true
    }
    login-de = {
      api_name         = "login-de"
      api_path         = "test"
      http_method      = "POST"
      endpoint_type    = "REGIONAL"
      lambda_invoke_arn = data.aws_lambda_function.revoke.invoke_arn
      authorization     = "AWS_IAM"
      stage_name       = "dev"
      api_key_required = true
    }
  }
}