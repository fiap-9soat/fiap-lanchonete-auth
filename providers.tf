provider "aws" {
  version    = "~> 5.0"
  region     = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
  token      = var.token_key
}
