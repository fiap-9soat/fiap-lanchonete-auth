variable "filename" {
  description = "The path to the Lambda function ZIP file"
  type        = string
}

variable "function_name" {
  description = "The name of the Lambda function"
  type        = string
}

variable "handler" {
  description = "The handler for the Lambda function"
  type        = string
}

variable "role" {
  description = "The ARN of the IAM role for the Lambda function"
  type        = string
}

variable "environment" {
  description = "Environment variables for the Lambda function"
  type = map(string)
}
