provider "aws" {
  version    = "~> 2.57"
  region     = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
}
