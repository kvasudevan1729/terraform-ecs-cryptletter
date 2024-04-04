variable "client_src_cidr_blocks" {
  type = list(string)
}

variable "cryptletter_vpc_cidr" {
  type = string
}

variable "cryptletter_ecs_app_count" {
  type = number
}

variable "cryptletter_dns_zone" {
  type = string
}

variable "cryptletter_cert_domain_name" {
  type = string
}

variable "cw_aws_region" {
  type = string
}