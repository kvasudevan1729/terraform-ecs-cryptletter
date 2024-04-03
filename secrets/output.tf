output "cryptletter_redis_secret_arn" {
  value = aws_secretsmanager_secret.cryptletter_redis_secret.arn
}

output "cryptletter_redis_secret_id" {
  value = aws_secretsmanager_secret.cryptletter_redis_secret.id
}