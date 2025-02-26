resource "aws_lambda_function" "lambda" {
  filename      = var.filename
  function_name = var.function_name
  role          = var.role
  handler       = var.handler
  runtime       = "nodejs18.x"
  source_code_hash = filebase64sha256(var.filename)

  environment {
    variables = var.environment
  }

}

