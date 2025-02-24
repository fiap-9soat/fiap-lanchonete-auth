variable "aws_region" {
  type        = string
  description = "The region in which the resources will be created"
  default     = "us-east-1"
}

variable "access_key" {
  type        = string
  description = "The aws development account access key"
}

variable "secret_key" {
  type        = string
  description = "The aws development account secret key"
}
