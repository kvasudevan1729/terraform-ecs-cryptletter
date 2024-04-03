data "terraform_remote_state" "cryptletter_ecs_iam" {
  backend = "s3"
  config = {
    bucket = "kv-tf-bucket"
    key    = "tf-ecs-cryptletter-iam"
    region = "eu-west-1"
  }
}

resource "aws_kms_key" "cryptletter_ecs" {
  description             = "cryptletter-ecs"
  deletion_window_in_days = 10
}

resource "aws_kms_alias" "cryptletter_ecs_alias" {
  name          = "alias/cryptletter-ecs"
  target_key_id = aws_kms_key.cryptletter_ecs.key_id
}

data "aws_iam_policy_document" "kms_decrypt_access_policy_doc" {
  statement {
    actions = [
      "kms:Decrypt",
    ]

    resources = [
      aws_kms_alias.cryptletter_ecs_alias.target_key_arn
    ]
  }
}

resource "aws_iam_policy" "kms_decrypt_policy" {
  name   = "kms-decrypt-policy"
  policy = data.aws_iam_policy_document.kms_decrypt_access_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_kms_policy" {
  role       = data.terraform_remote_state.cryptletter_ecs_iam.outputs.ecs_task_exec_role_name
  policy_arn = aws_iam_policy.kms_decrypt_policy.arn
}