variable "ecs_vpc_name" {
  type = string
}

variable "ecs_vpc_cidr" {
  type = string
}

variable "ecs_vpc_private_subnets" {
  type = list(string)
}

variable "ecs_vpc_public_subnets" {
  type = list(string)
}
