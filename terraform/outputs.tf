output "cluster_name" {
  description = "EKS Cluster Name"
  value       = module.eks.cluster_name
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "bastion_public_ip" {
  description = "Public IP of Bastion Host"
  value       = module.bastion_host.public_ip
}

output "rds_endpoint" {
  description = "RDS PostgreSQL Endpoint"
  value       = aws_db_instance.postgres.endpoint
}

output "rds_database_name" {
  description = "RDS Database Name"
  value       = aws_db_instance.postgres.db_name
}

output "public_subnets" {
  description = "Public Subnet IDs"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "Private Subnet IDs"
  value       = module.vpc.private_subnets
}