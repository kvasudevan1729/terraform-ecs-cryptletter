data "aws_iam_policy_document" "ecr_pull_access_policy_doc" {
  statement {
    effect = "Allow"
    actions = [
      "ecr:CompleteLayerUpload",
      "ecr:GetAuthorizationToken",
      "ecr:UploadLayerPart",
      "ecr:InitiateLayerUpload",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "ecr_pull_policy" {
  name   = "ecr-pull-policy"
  policy = data.aws_iam_policy_document.ecr_pull_access_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_ecr_policy" {
  role       = data.terraform_remote_state.cryptletter_ecs_iam.outputs.ecs_task_exec_role_name
  policy_arn = aws_iam_policy.ecr_pull_policy.arn
}
