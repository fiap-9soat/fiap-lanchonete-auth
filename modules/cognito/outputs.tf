output "user_pool_id" {
  description = "ID of the created user pool"
  value       = aws_cognito_user_pool.user_pool.id
}

output "client_id" {
  description = "ID of the created user pool client"
  value       = aws_cognito_user_pool_client.client.id
}
