data "terraform_remote_state" "cryptletter_ecs_iam" {
  backend = "s3"
  config = {
    bucket = "kv-tf-bucket"
    key    = "tf-ecs-cryptletter-iam"
  }
}

data "terraform_remote_state" "cryptletter_ecs_kms_state" {
  backend = "s3"
  config = {
    bucket = "kv-tf-bucket"
    key    = "tf-ecs-cryptletter-kms"
  }
}