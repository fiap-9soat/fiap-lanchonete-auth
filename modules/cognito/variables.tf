variable "user_pool_name" {
  description = "The name of the Cognito User Pool"
  type        = string
  default     = "fiap-user-pool"
}

variable "client_name" {
  description = "The name of the Cognito User Pool Client"
  type        = string
  default     = "fiap-cognito-client"
}

variable "domain" {
  description = "The URL domain of the Cognito client"
  type        = string
}
