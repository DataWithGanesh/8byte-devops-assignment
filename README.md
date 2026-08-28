# 8Byte DevOps Assignment

## Overview

This repository contains Infrastructure as Code (IaC), containerization, Kubernetes deployment manifests, and CI/CD automation for deploying a sample Node.js application on AWS.

The infrastructure is provisioned using Terraform and follows security, scalability, and operational best practices.

---

## Architecture

### Components

- AWS VPC
- Public Subnets
- Private Subnets
- NAT Gateway
- Bastion Host
- Amazon EKS Cluster
- PostgreSQL RDS
- Security Groups
- S3 Backend for Terraform State
- Kubernetes Deployment & Service
- Docker Containerization

### High-Level Architecture

```text
Internet
   |
Application Load Balancer
   |
EKS Cluster (Private Subnets)
   |
PostgreSQL RDS

Bastion Host (Public Subnet)

Terraform State
      |
      S3 Backend
```

---

## Terraform Structure

```text
terraform/
├── terraform.tf
├── variables.tf
├── terraform.tfvars.example
├── vpc.tf
├── eks.tf
├── rds.tf
├── bastion-ec2.tf
├── data.tf
├── outputs.tf
```

---

## Infrastructure Provisioned

### Networking

- Custom VPC
- 3 Public Subnets
- 3 Private Subnets
- Internet Gateway
- NAT Gateway
- Route Tables

### Compute

- Bastion Host (EC2)
- Amazon EKS Cluster
- Managed Node Groups

### Database

- PostgreSQL RDS
- Multi-layer security through Security Groups
- Automated Backups
- Deletion Protection

### State Management

Terraform remote state stored in AWS S3.

---

## Security Considerations

The following security controls were implemented:

### Network Security

- Private subnets for EKS worker nodes
- Private subnets for PostgreSQL RDS
- Restricted Security Group Rules
- Bastion Host access restricted to client public IP

### Data Protection

- RDS Storage Encryption Enabled
- Performance Insights Encryption Enabled
- KMS Key Rotation Enabled
- IAM Database Authentication Enabled

### Infrastructure Security

- IMDSv2 Enforced on EC2 Instances
- Private EKS API Endpoint Enabled
- Terraform State Stored Remotely
- VPC Flow Logs Enabled

---

## Cost Optimization

To minimize infrastructure costs:

- t3.micro instances used where possible
- Single NAT Gateway configuration
- Minimal EKS Node Group sizing
- RDS storage limited to required capacity
- Automated backup retention configured for 7 days

---

## Backup Strategy

### PostgreSQL RDS

- Automated backups enabled
- Backup retention period: 7 days
- Final snapshot created before deletion
- Deletion protection enabled

### Terraform State

- Remote backend stored in S3
- State centralized and recoverable

---

## Terraform Commands

Initialize Terraform:

```bash
terraform init
```

Format Terraform Code:

```bash
terraform fmt
```

Validate Configuration:

```bash
terraform validate
```

Generate Execution Plan:

```bash
terraform plan
```

Apply Infrastructure:

```bash
terraform apply
```

Destroy Infrastructure:

```bash
terraform destroy
```

---

## Prerequisites

- Terraform >= 1.5
- AWS Account
- AWS CLI Configured
- Docker
- kubectl
- IAM Permissions for:
  - VPC
  - EKS
  - EC2
  - RDS
  - S3

---

## Docker

Build Docker Image:

```bash
docker build -t 8byte-devops-app .
```

Run Container:

```bash
docker run -d -p 3000:3000 8byte-devops-app
```

Docker Hub Repository:

https://hub.docker.com/repositories/ganesh492

---

## Kubernetes Deployment

Deploy Application:

```bash
kubectl apply -f k8s/deployment.yaml
```

Deploy Service:

```bash
kubectl apply -f k8s/service.yaml
```

Verify Pods:

```bash
kubectl get pods
```

Verify Services:

```bash
kubectl get svc
```

---

## Application Endpoints

### Root Endpoint

```http
GET /
```

Response:

```json
{
  "message": "8Byte DevOps Assignment",
  "status": "success"
}
```

### Health Endpoint

```http
GET /health
```

Response:

```json
{
  "status": "healthy"
}
```

---

## Challenges Faced

### Challenge 1

Terraform formatting failures during CI execution.

**Resolution:**
Used terraform fmt and verified formatting locally before pushing changes.

### Challenge 2

Security findings reported by tfsec.

**Resolution:**
Restricted security group rules, enabled encryption, enabled IAM authentication, enforced IMDSv2, enabled VPC Flow Logs, and configured KMS key rotation.

### Challenge 3

EKS module compatibility issues with secret encryption configuration.

**Resolution:**
Investigated module limitations and documented the production-ready approach using KMS-based secret encryption.

---

## Future Improvements

- Enable EKS Secret Encryption with Customer Managed KMS Keys
- Integrate Prometheus & Grafana Monitoring
- Configure Centralized Logging using CloudWatch
- Implement ArgoCD GitOps Deployment
- Add Slack Notifications for CI/CD Failures

---

## Author

Ganesh Iranna Karadgi
