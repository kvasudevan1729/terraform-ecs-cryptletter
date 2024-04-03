output "cryptletter_ecs_cw_log_group_id" {
  value = aws_cloudwatch_log_group.cryptletter_ecs_log_group.id
}

output "cryptletter_ecs_cluster_id" {
  value = aws_ecs_cluster.cryptletter_ecs_cluster.id
}