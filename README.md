# 8Byte DevOps Assignment

## Author

**Ganesh Iranna Karadgi**

---

# Assignment Objective

This project demonstrates the implementation of a production-oriented DevOps platform on AWS using Infrastructure as Code, CI/CD automation, security scanning, monitoring, logging, and deployment best practices.

The solution covers:

- Infrastructure Provisioning using Terraform
- Application Containerization using Docker
- Kubernetes Deployment
- CI/CD Automation using GitHub Actions
- Security Scanning
- Monitoring & Observability
- Centralized Logging
- Production Deployment Workflow
- Documentation & Operational Readiness

---

# Architecture Overview

## Infrastructure Components

### AWS Networking

- VPC
- Internet Gateway
- NAT Gateway
- Public Subnets
- Private Subnets
- Route Tables
- Security Groups

### Compute

- Bastion Host (EC2)
- Amazon EKS Cluster
- Managed Node Groups

### Database

- PostgreSQL RDS

### Application

- Node.js Application
- Docker Container
- Kubernetes Deployment
- Kubernetes Service

### CI/CD

- GitHub Repository
- GitHub Actions
- Docker Hub Registry

### Monitoring

- Prometheus
- Grafana
- Infrastructure Dashboard
- Application Dashboard

### Logging

- Fluent Bit
- CloudWatch Agent
- CloudWatch Logs

### Security

- tfsec
- Trivy
- Security Groups
- KMS Encryption
- VPC Flow Logs

---

# High Level Architecture

```text

Developer
    |
    v

GitHub Repository
    |
    v

GitHub Actions CI/CD Pipeline
    |
    +-------------------------+
    |                         |
    v                         v

Terraform Validation      Security Scans
(tf fmt/validate)         (tfsec + Trivy)

    |
    v

Docker Build
    |
    v

Docker Hub
    |
    v

Kubernetes Deployment
    |
    v

Amazon EKS
    |
    v

Node.js Application Pods
    |
    v

PostgreSQL RDS

```

---

# Repository Structure

```text

8byte-devops-assignment/

├── app/
│   ├── server.js
│   ├── Dockerfile
│   ├── package.json
│
├── terraform/
│   ├── vpc.tf
│   ├── eks.tf
│   ├── rds.tf
│   ├── bastion-ec2.tf
│   ├── variables.tf
│   ├── outputs.tf
│
├── k8s/
│   ├── deployment.yaml
│   ├── service.yaml
│
├── monitoring/
│   ├── prometheus-config.yaml
│   ├── grafana-dashboard-app.json
│   ├── grafana-dashboard-infra.json
│   └── dashboards.md
│
├── logging/
│   ├── fluent-bit-config.yaml
│   └── cloudwatch-agent-config.json
│
├── .github/
│   └── workflows/
│       └── ci-cd.yml
│
├── challenges.md
│
└── README.md

```

---

# Infrastructure Provisioning

Infrastructure is provisioned using Terraform.

## Resources Created

### Networking

- VPC
- Internet Gateway
- NAT Gateway
- Public Subnets
- Private Subnets
- Route Tables

### Security

- Security Groups
- Restricted Network Access
- VPC Flow Logs

### Compute

- Bastion Host
- Amazon EKS Cluster
- EKS Managed Node Groups

### Database

- PostgreSQL RDS
- Storage Encryption
- Automated Backups
- Deletion Protection

---

# CI/CD Pipeline

GitHub Actions automates the complete deployment workflow.

## Pipeline Stages

### 1. Unit Tests

```bash
npm test
```

### 2. Integration Tests

Application health validation.

### 3. Terraform Validation

```bash
terraform fmt -check
terraform validate
```

### 4. Terraform Security Scan

```bash
tfsec
```

### 5. Docker Build

```bash
docker build
```

### 6. Docker Push

```bash
docker push
```

### 7. Container Vulnerability Scan

```bash
trivy
```

### 8. Kubernetes Manifest Validation

```bash
kubeconform
```

### 9. Staging Deployment

GitHub Environment: staging

### 10. Production Deployment

GitHub Environment: production

### 11. Failure Notification Stage

Pipeline notification placeholder for Slack/Email integration.

---

# Monitoring Implementation

Monitoring configuration is provided for production deployment.

## Prometheus Metrics

Application exposes:

```text
/metrics
```

Collected Metrics:

- Request Count
- Error Count
- Request Duration
- Application Availability

---

## Grafana Dashboards

### Infrastructure Dashboard

Monitors:

- CPU Usage
- Memory Usage
- Network Traffic
- Node Health

### Application Dashboard

Monitors:

- Request Rate
- Error Rate
- Response Time
- Application Availability

Dashboard definitions:

```text
monitoring/grafana-dashboard-app.json
monitoring/grafana-dashboard-infra.json
```

---

# Logging Implementation

Centralized logging architecture prepared.

## Fluent Bit

Collects:

```text
/var/log/containers/*.log
```

Forwards logs to CloudWatch.

---

## CloudWatch Agent

Collects:

```text
/var/log/messages
/var/log/secure
```

---

## Log Categories

### Application Logs

- Node.js Application Logs

### System Logs

- EC2 System Logs

### Access Logs

- Kubernetes Container Logs

---

# Security Controls Implemented

## Infrastructure Security

- Security Groups
- Private Subnets
- Bastion Access Restriction
- VPC Flow Logs

## Data Protection

- RDS Encryption
- KMS Key Rotation
- IAM Database Authentication

## Container Security

- Trivy Vulnerability Scanning

## Infrastructure Security Scanning

- tfsec Security Validation

## Compute Security

- IMDSv2 Enabled
- Private EKS Endpoint

---

# Docker

Build Image

```bash
docker build -t 8byte-devops-app .
```

Run Container

```bash
docker run -p 3000:3000 8byte-devops-app
```

Docker Hub Repository

https://hub.docker.com/repositories/ganesh492

---

# Kubernetes Deployment

Deploy Application

```bash
kubectl apply -f k8s/deployment.yaml
```

Deploy Service

```bash
kubectl apply -f k8s/service.yaml
```

Verify

```bash
kubectl get pods
kubectl get svc
```

---

# Application Endpoints

## Root Endpoint

```http
GET /
```

Response

```json
{
  "message": "8Byte DevOps Assignment",
  "status": "success"
}
```

---

## Health Endpoint

```http
GET /health
```

Response

```json
{
  "status": "healthy"
}
```

---

# Screenshots

Screenshots of the implementation are available under:

```text
/screenshots
```

Suggested screenshots:

- GitHub Actions Success Pipeline
- Terraform Validation
- tfsec Scan
- Trivy Scan
- Docker Hub Image
- GitHub Environments
- Monitoring Configuration
- Logging Configuration

---

# Challenges & Resolutions

Detailed implementation challenges and resolutions are documented in:

```text
challenges.md
```

The document contains:

- Security Findings
- Terraform Issues
- CI/CD Challenges
- Monitoring Challenges
- Logging Challenges
- Production Deployment Decisions

---

# Production Deployment Note

Production deployment is configured through GitHub Environments.

In a real enterprise setup:

- Required Reviewers would be enforced
- Change Management Approval would be required
- Deployment Gates would be enabled

For assessment purposes, deployment flow is demonstrated using GitHub Environments.

---

# Future Improvements

- Deploy monitoring stack directly on EKS
- Slack Notifications
- ArgoCD GitOps Deployment
- Automated Rollback Strategy
- Blue/Green Deployment
- Multi-Region Disaster Recovery

---

# Assignment Deliverables

Terraform Infrastructure
Docker Containerization
Kubernetes Deployment
GitHub Actions CI/CD
tfsec Security Scanning
Trivy Vulnerability Scanning
Monitoring Configuration
Logging Configuration
Production Deployment Workflow
Challenges Documentation
Architecture Documentation
Security Best Practices

## Secret Management

GitHub Actions Secrets are used to securely manage sensitive CI/CD credentials.

Configured Secrets:

- DOCKER_USERNAME
- DOCKER_PASSWORD

No sensitive credentials are stored in source code.

---

## Backup Strategy

PostgreSQL RDS is configured with:

- Automated Backups
- Backup Retention Period
- Deletion Protection
- Final Snapshot Before Deletion

This provides recovery capability in case of accidental deletion or data corruption.

## Database Monitoring

The monitoring stack includes PostgreSQL RDS metrics collected through CloudWatch.

Tracked Metrics:

- CPU Utilization
- Database Connections
- Read Latency
- Write Latency
- Free Storage Space
- Freeable Memory

These metrics can be visualized through Grafana dashboards using CloudWatch as a datasource.
