variable "region" {
  description = "The AWS region"
  type        = string
}

variable "lambdas" {
  description = "A map of Lambda ARNs for the API Gateway integrations"
  type = map(string)
}
