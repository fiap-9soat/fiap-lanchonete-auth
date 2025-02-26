module "cognito" {
  source = "modules/cognito"
  # Must be unique
  domain = "fiap-lanchonete-login"
}

module "sign_up_lambda" {
  source        = "modules/lambda"
  function_name = "signUpFunction"
  filename      = "lambda/sign_up/lambda_function_payload.zip"
  handler       = "index.handler"
  role          = var.role_arn
  environment = {
    USER_POOL_ID = module.cognito.user_pool_id
  }
}

module "sign_in_lambda" {
  source        = "modules/lambda"
  function_name = "signInFunction"
  filename      = "lambda/sign_in/lambda_function_payload.zip"
  handler       = "index.handler"
  role          = var.role_arn
  environment = {
    USER_POOL_ID = module.cognito.user_pool_id
    CLIENT_ID    = module.cognito.client_id
  }
}

module "api_gateway" {
  source = "modules/api_gateway"
  lambdas = {
    sign_up = module.sign_up_lambda.lambda_arn
    sign_in = module.sign_in_lambda.lambda_arn
  }
}
