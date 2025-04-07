# resource "aws_api_gateway_rest_api" "this" {
#   name        = var.api_name
#   description = "API Gateway with Lambda Integration"

#   endpoint_configuration {
#     types = [var.endpoint_type]
#   }
# }

# resource "aws_api_gateway_resource" "resource" {
#   rest_api_id = aws_api_gateway_rest_api.this.id
#   parent_id   = aws_api_gateway_rest_api.this.root_resource_id
#   path_part   = var.api_path
# }

# resource "aws_api_gateway_method" "method" {
#   rest_api_id   = aws_api_gateway_rest_api.this.id
#   resource_id   = aws_api_gateway_resource.resource.id
#   http_method   = var.http_method
#   authorization = var.authorization
#   api_key_required = var.api_key_required
# }

# resource "aws_api_gateway_integration" "lambda" {
#   rest_api_id             = aws_api_gateway_rest_api.this.id
#   resource_id             = aws_api_gateway_resource.resource.id
#   http_method             = aws_api_gateway_method.method.http_method
#   integration_http_method = "POST"
#   type                    = "AWS"
#   uri                     = var.lambda_invoke_arn
# }

# resource "aws_api_gateway_deployment" "deployment" {
#   depends_on  = [aws_api_gateway_integration.lambda]
#   rest_api_id = aws_api_gateway_rest_api.this.id
#   stage_name  = var.stage_name
# }

# resource "aws_lambda_permission" "apigw" {
#   statement_id  = "rfe"
#   action        = "lambda:InvokeFunction"
#   function_name = var.lambda_name
#   principal     = "apigateway.amazonaws.com"
#   source_arn    = "${aws_api_gateway_rest_api.this.execution_arn}/*/*"
# }

# resource "aws_api_gateway_method_response" "response_200" {
#   rest_api_id = aws_api_gateway_rest_api.this.id
#   resource_id = aws_api_gateway_resource.resource.id
#   http_method = aws_api_gateway_method.method.http_method
#   status_code = "200"
# }

# resource "aws_api_gateway_integration_response" "MyDemoIntegrationResponse" {
#   rest_api_id = aws_api_gateway_rest_api.this.id
#   resource_id = aws_api_gateway_resource.resource.id
#   http_method = aws_api_gateway_method.method.http_method
#   status_code = aws_api_gateway_method_response.response_200.status_code

#   # Transforms the backend JSON response to XML
#   response_templates = {
#     "application/xml" = <<EOF
# #set($inputRoot = $input.path('$'))
# <?xml version="1.0" encoding="UTF-8"?>
# <message>
#     $inputRoot.body
# </message>
# EOF
#   }
# }

# output "api_gateway_url" {
#   value = aws_api_gateway_deployment.deployment.invoke_url
# }
# variable "api_name" {}
# variable "api_path" {}
# variable "http_method" {}
# variable "stage_name" {}
# variable "lambda_invoke_arn" {}
# variable "lambda_name" {}
# variable "endpoint_type" {}

# variable "authorization" {}
# variable "api_key_required" {}