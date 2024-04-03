output "cryptletter_kms_arn" {
  value = aws_kms_alias.cryptletter_ecs_alias.target_key_arn
}
