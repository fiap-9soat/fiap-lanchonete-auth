resource "aws_lambda_function" "pre_signup" {
  filename = "lambda/pre_signup/lambda_pre_signup_payload.zip"
  function_name = "validarCpf"
  # Use o ARN de uma role existente com permissão!
  role     = "arn:aws:iam::353900409457:role/LabRole"
  handler  = "index.handler"
  runtime  = "nodejs18.x"
  source_code_hash = filebase64sha256("lambda/pre_signup/lambda_pre_signup_payload.zip")
}


resource "aws_cognito_user_pool" "user_pool" {
  depends_on = [aws_lambda_function.pre_signup]
  name = "fiap-user-pool"

  username_attributes = ["email"]
  auto_verified_attributes = ["email"]
  password_policy {
    minimum_length = 6
  }

  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
    email_subject        = "Account Confirmation"
    email_message        = "Your confirmation code is {####}"
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "email"
    required                 = true

    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "cpf"
    required                 = false

    string_attribute_constraints {
      min_length = 11
      max_length = 11
    }
  }

  lambda_config {
    pre_sign_up = aws_lambda_function.pre_signup.arn
  }
}

resource "aws_cognito_user_pool_client" "client" {
  name = "cognito-client"

  user_pool_id                  = aws_cognito_user_pool.user_pool.id
  generate_secret               = false
  refresh_token_validity        = 90
  prevent_user_existence_errors = "ENABLED"
  explicit_auth_flows = [
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_ADMIN_USER_PASSWORD_AUTH"
  ]

}

resource "aws_cognito_user_pool_domain" "cognito-domain" {
  # O dominio (URL) da tela de login - deve ser unico
  domain       = "fiap-lanchonete-domain"
  user_pool_id = aws_cognito_user_pool.user_pool.id
}
