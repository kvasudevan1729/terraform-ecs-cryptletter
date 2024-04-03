data "terraform_remote_state" "cryptletter_ecs_iam" {
  backend = "s3"
  config = {
    bucket = "kv-tf-bucket"
    key    = "tf-ecs-cryptletter-iam"
    region = "eu-west-1"
  }
}

data "terraform_remote_state" "cryptletter_ecs_kms_state" {
  backend = "s3"
  config = {
    bucket = "kv-tf-bucket"
    key    = "tf-ecs-cryptletter-kms"
    region = "eu-west-1"
  }
}