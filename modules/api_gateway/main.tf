resource "aws_api_gateway_rest_api" "api" {
  name        = "auth-api"
  description = "API for user authentication"
}

resource "aws_api_gateway_resource" "sign_up" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "sign-up"
}

resource "aws_api_gateway_resource" "sign_in" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "sign-in"
}

resource "aws_api_gateway_resource" "password_recovery" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "password-recovery"
}

resource "aws_api_gateway_method" "sign_up_post" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.sign_up.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "sign_in_post" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.sign_in.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "password_recovery_post" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.password_recovery.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "sign_up_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.sign_up.id
  http_method             = aws_api_gateway_method.sign_up_post.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${var.lambdas.sign_up}/invocations"
}

resource "aws_api_gateway_integration" "sign_in_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.sign_in.id
  http_method             = aws_api_gateway_method.sign_in_post.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${var.lambdas.sign_in}/invocations"
}

resource "aws_api_gateway_integration" "password_recovery_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.password_recovery.id
  http_method             = aws_api_gateway_method.password_recovery_post.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${var.lambdas.password_recovery}/invocations"
}

resource "aws_lambda_permission" "sign_up_api_gateway" {
  statement_id  = "AllowAPIGatewayInvokeSignUp"
  action        = "lambda:InvokeFunction"
  function_name = var.lambdas.sign_up
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "sign_in_api_gateway" {
  statement_id  = "AllowAPIGatewayInvokeSignIn"
  action        = "lambda:InvokeFunction"
  function_name = var.lambdas.sign_in
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "password_recovery_api_gateway" {
  statement_id  = "AllowAPIGatewayInvokePasswordRecovery"
  action        = "lambda:InvokeFunction"
  function_name = var.lambdas.password_recovery
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [
    aws_api_gateway_integration.sign_up_lambda,
    aws_api_gateway_integration.sign_in_lambda,
    aws_api_gateway_integration.password_recovery_lambda
  ]

  rest_api_id = aws_api_gateway_rest_api.api.id
}
