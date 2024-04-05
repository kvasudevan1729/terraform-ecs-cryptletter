output "ecs_vpc_id" {
  value = module.vpc.vpc_id
}

output "ecs_vpc_igw_id" {
  value = module.vpc.igw_id
}

output "ecs_vpc_nat_gw_id" {
  value = module.vpc.natgw_ids
}

# Subnets
output "ecs_vpc_private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "ecs_vpc_public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

# CIDRs
output "ecs_vpc_private_subnet_cidrs" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets_cidr_blocks
}

output "ecs_vpc_public_subnet_cidrs" {
  description = "List of IDs of private subnets"
  value       = module.vpc.public_subnets_cidr_blocks
}

output "ecs_vpc_default_security_group_id" {
  description = "The ID of the security group created by default on VPC creation"
  value       = module.vpc.default_security_group_id
}