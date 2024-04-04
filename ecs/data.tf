data "terraform_remote_state" "cryptletter_ecs_iam" {
  backend = "s3"
  config = {
    bucket = "kv-tf-bucket"
    key    = "tf-ecs-cryptletter-iam"
  }
}

data "terraform_remote_state" "cryptletter_ecs_secret" {
  backend = "s3"
  config = {
    bucket = "kv-tf-bucket"
    key    = "tf-ecs-cryptletter-secret"
  }
}

data "aws_vpc" "cryptletter_vpc" {
  cidr_block = var.cryptletter_vpc_cidr
}

data "aws_route53_zone" "cryptletter_dns_zone" {
  name = var.cryptletter_dns_zone
}

data "aws_acm_certificate" "cryptletter_cert" {
  domain = var.cryptletter_cert_domain_name
}

data "aws_subnets" "cryptletter_private_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.cryptletter_vpc.id]
  }

  tags = {
    Tier = "private"
  }
}

data "aws_subnets" "cryptletter_public_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.cryptletter_vpc.id]
  }

  tags = {
    Tier = "public"
  }
}