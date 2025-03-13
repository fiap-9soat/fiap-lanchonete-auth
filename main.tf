locals {
  iam_role_arn       = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/LabRole"
}

data "aws_caller_identity" "current" {}

module "cognito" {
  source = "./modules/cognito"
  # Must be unique
  domain = var.cognito_domain
}

module "sign_up_lambda" {
  source        = "./modules/lambda"
  function_name = "signUpFunction"
  filename      = "lambda/sign_up/lambda_function_payload.zip"
  handler       = "index.handler"
  role          = local.iam_role_arn
  environment = {
    USER_POOL_ID = module.cognito.user_pool_id
  }
}

module "sign_in_lambda" {
  source        = "./modules/lambda"
  function_name = "signInFunction"
  filename      = "lambda/sign_in/lambda_function_payload.zip"
  handler       = "index.handler"
  role          = local.iam_role_arn
  environment = {
    USER_POOL_ID = module.cognito.user_pool_id
    CLIENT_ID    = module.cognito.client_id
  }
}

module "password_recovery_lambda" {
  source        = "./modules/lambda"
  function_name = "passwordRecoveryFunction"
  filename      = "lambda/password_recovery/lambda_function_payload.zip"
  handler       = "index.handler"
  role          = local.iam_role_arn
  environment = {
    CLIENT_ID = module.cognito.client_id
  }
}

module "api_gateway" {
  source = "./modules/api_gateway"
  region = var.aws_region
  lambdas = {
    sign_up           = module.sign_up_lambda.lambda_arn
    sign_in           = module.sign_in_lambda.lambda_arn
    password_recovery = module.password_recovery_lambda.lambda_arn
  }
}
