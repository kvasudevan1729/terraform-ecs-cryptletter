locals {
  region = "eu-west-1"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.7.0"

  name = var.ecs_vpc_name
  cidr = var.ecs_vpc_cidr

  azs             = ["${local.region}a", "${local.region}b", "${local.region}c"]
  private_subnets = var.ecs_vpc_private_subnets
  public_subnets  = var.ecs_vpc_public_subnets

  manage_default_security_group = false

  enable_nat_gateway = true
  single_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Owner       = "ecs-lab"
    Environment = "lab"
  }

  vpc_tags = {
    Name = var.ecs_vpc_name
  }

  public_subnet_tags = {
    Tier = "public"
  }

  private_subnet_tags = {
    Tier = "private"
  }
}
