# 8Byte DevOps Assignment

## Infrastructure

- VPC
- Public Subnets
- Private Subnets
- NAT Gateway
- Bastion Host
- EKS Cluster
- PostgreSQL RDS
- S3 Backend for Terraform State

## Terraform Structure

terraform/
├── terraform.tf

├── variables.tf
├── terraform.tfvars.example
├── vpc.tf
├── eks.tf
├── rds.tf
├── bastion-ec2.tf
├── data.tf
└── outputs.tf

## Security

- Private RDS
- Security Groups
- Encrypted Storage
- Remote Terraform State

## Architecture

- VPC with public and private subnets
- Bastion host deployed in public subnet
- EKS cluster deployed in private subnets
- PostgreSQL RDS deployed in private subnets
- NAT Gateway provides outbound internet access for private resources
- Terraform state stored remotely in S3 backend

## Terraform Commands

terraform init
terraform fmt
terraform validate
terraform plan
terraform apply

## Prerequisites

- Terraform >= 1.5
- AWS Account
- AWS CLI Configured
- IAM Permissions for VPC, EKS, EC2, RDS and S3
