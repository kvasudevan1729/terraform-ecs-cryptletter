# create the secret object but the secret value will be added manually
# to avoid the value getting into tf state

resource "aws_secretsmanager_secret" "cryptletter_redis_secret" {
  name                    = "cryptletter-redis-password"
  kms_key_id              = data.terraform_remote_state.cryptletter_ecs_kms_state.outputs.cryptletter_kms_arn
  recovery_window_in_days = 0

  tags = {
    Apps = "core - security"
  }
}

data "aws_iam_policy_document" "secret_manager_access_policy_doc" {
  statement {
    sid = "1"

    actions = [
      "secretsmanager:GetSecretValue",
    ]

    resources = [
      aws_secretsmanager_secret.cryptletter_redis_secret.arn
    ]
  }
}

resource "aws_iam_policy" "secret_manager_access_policy" {
  name   = "secret-manager-access-policy"
  policy = data.aws_iam_policy_document.secret_manager_access_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_sm_policy" {
  role       = data.terraform_remote_state.cryptletter_ecs_iam.outputs.ecs_task_exec_role_name
  policy_arn = aws_iam_policy.secret_manager_access_policy.arn
}