variable "api_gateways" {
  description = "A map of API Gateway configurations"
  type        = map(object({
    api_name         = string
    api_path         = string
    http_method      = string
    endpoint_type    = string
    lambda_invoke_arn = string
    authorization    = string
    stage_name       = string
    api_key_required = bool
  }))
}

resource "aws_api_gateway_rest_api" "this" {
  for_each    = var.api_gateways
  name        = each.value.api_name
  description = "API Gateway with Lambda Integration"

  endpoint_configuration {
    types = [each.value.endpoint_type]
  }
}

resource "aws_api_gateway_resource" "resource" {
  for_each   = var.api_gateways
  rest_api_id = aws_api_gateway_rest_api.this[each.key].id
  parent_id   = aws_api_gateway_rest_api.this[each.key].root_resource_id
  path_part   = each.value.api_path
}

resource "aws_api_gateway_method" "method" {
  for_each      = var.api_gateways
  rest_api_id   = aws_api_gateway_rest_api.this[each.key].id
  resource_id   = aws_api_gateway_resource.resource[each.key].id
  http_method   = each.value.http_method
  authorization = each.value.authorization
  api_key_required = each.value.api_key_required
}

resource "aws_api_gateway_integration" "lambda" {
  for_each               = var.api_gateways
  rest_api_id             = aws_api_gateway_rest_api.this[each.key].id
  resource_id             = aws_api_gateway_resource.resource[each.key].id
  http_method             = aws_api_gateway_method.method[each.key].http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = each.value.lambda_invoke_arn
}

resource "aws_api_gateway_deployment" "deployment" {
  for_each   = var.api_gateways
  depends_on  = [aws_api_gateway_integration.lambda]
  rest_api_id = aws_api_gateway_rest_api.this[each.key].id
  stage_name  = each.value.stage_name
}

resource "aws_lambda_permission" "apigw" {
  for_each      = var.api_gateways
  statement_id  = element(regex("arn:aws:lambda:[^:]+:[^:]+:function:([^/]+)", each.value.lambda_invoke_arn), 0)
  action        = "lambda:InvokeFunction"
  function_name = element(regex("arn:aws:lambda:[^:]+:[^:]+:function:([^/]+)", each.value.lambda_invoke_arn), 0)
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.this[each.key].execution_arn}/*/*"
}

resource "aws_api_gateway_method_response" "response_200" {
  for_each    = var.api_gateways
  rest_api_id = aws_api_gateway_rest_api.this[each.key].id
  resource_id = aws_api_gateway_resource.resource[each.key].id
  http_method = aws_api_gateway_method.method[each.key].http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "integration_response" {
  for_each    = var.api_gateways
  rest_api_id = aws_api_gateway_rest_api.this[each.key].id
  resource_id = aws_api_gateway_resource.resource[each.key].id
  http_method = aws_api_gateway_method.method[each.key].http_method
  status_code = aws_api_gateway_method_response.response_200[each.key].status_code

  response_templates = {
    "application/xml" = <<EOF
#set($inputRoot = $input.path('$'))
<?xml version="1.0" encoding="UTF-8"?>
<message>
    $inputRoot.body
</message>
EOF
  }
}

output "api_gateway_urls" {
  value = { for k, v in aws_api_gateway_deployment.deployment : k => v.invoke_url }
}