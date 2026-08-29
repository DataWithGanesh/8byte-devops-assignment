## Challenge 1: EKS Secret Encryption Not Enabled

### Objective

Provision a secure Amazon EKS cluster following AWS security best practices and validate the infrastructure using automated security scanning.

### Problem Encountered

During Terraform security validation using tfsec, the following HIGH severity finding was identified:

aws-eks-encrypt-secrets
Cluster does not have secret encryption enabled

### Root Cause Analysis

The EKS cluster was provisioned using the official terraform-aws-eks module.

By default, Kubernetes secret encryption is not enabled unless an AWS KMS key is explicitly configured and attached to the cluster encryption configuration.

As a result:

- Kubernetes secrets are stored in etcd.
- Secrets are only Base64 encoded by default.
- Sensitive application data remains vulnerable if the control plane is compromised.

### Impact Assessment

Potential exposure of:

- Database credentials
- API keys
- Application secrets
- Service account tokens

This issue was classified as HIGH severity due to the potential security impact on sensitive workloads.

### Resolution Approach

Implemented AWS KMS-backed encryption for Kubernetes secrets.
Created a dedicated KMS key and associated it with the EKS cluster through Terraform.
Updated cluster configuration to encrypt secret resources at rest.

### Outcome

Kubernetes secrets encrypted at rest
Improved security posture
Compliance with AWS security recommendations
tfsec finding successfully remediated

### Key Takeaway

Security scanning should be integrated early in the Infrastructure-as-Code lifecycle to identify and remediate configuration risks before deployment.

## Challenge 2: Public Subnets Flagged by tfsec

### Objective

Design a secure and scalable AWS network architecture capable of supporting internet-facing services while maintaining isolation for internal workloads.

### Problem Encountered

During Terraform security validation using tfsec, the following HIGH severity finding was reported:

aws-ec2-no-public-ip-subnet

Subnet associates public IP address

### Root Cause Analysis

The infrastructure was intentionally designed using a combination of public and private subnets to follow a standard AWS multi-tier architecture.

The public subnets are required for:

- Internet-facing Application Load Balancer (ALB)
- NAT Gateway deployment
- External ingress traffic

The Terraform AWS VPC module automatically configures:

map_public_ip_on_launch = true

for resources deployed into public subnets.

As a result, tfsec identified the configuration as a potential security concern because instances launched within these subnets can receive public IP addresses.

### Impact Assessment

From a security scanning perspective, public IP assignment increases the attack surface and may expose workloads directly to the internet if not properly controlled.

Potential risks include:

- Unintended public exposure of resources
- Increased external attack surface
- Misconfigured security group access

However, in this architecture:

- Public subnets are intentionally designed for internet-facing components
- Application workloads are hosted in private subnets
- Database resources remain isolated in private subnets
- Security Groups enforce controlled network access

### Resolution Approach

The finding was reviewed against the intended network architecture and AWS reference design patterns.

After evaluation, no remediation was applied because:

- Public subnet usage is a functional requirement
- NAT Gateway requires placement within public subnets
- Internet-facing ALBs must reside in public subnets
- Private workloads remain isolated through subnet segmentation

Additional security controls were implemented through:

- Security Groups
- Private subnet isolation
- Restricted ingress rules
- Network segmentation

### Outcome

Architecture validated against AWS reference design
Internet-facing services remain accessible
Private application and database workloads remain isolated
Security controls enforced through subnet segregation and Security Groups
Risk formally reviewed and accepted

### Key Takeaway

Security scanner findings should always be evaluated in the context of architectural requirements. While automated tools provide valuable guidance, some findings represent intentional design decisions required to support business and operational objectives.

## Challenge 3: VPC Flow Logs Not Enabled

### Objective

Implement a secure and observable AWS network architecture capable of providing visibility into network traffic for monitoring, troubleshooting, and security investigations.

### Problem Encountered

During Terraform security validation using tfsec, the following MEDIUM severity finding was reported:

aws-ec2-require-vpc-flow-logs-for-all-vpcs

VPC Flow Logs is not enabled for VPC

### Root Cause Analysis

The initial implementation focused on provisioning the core infrastructure components required by the assignment, including:

- VPC and Subnets
- EKS Cluster
- PostgreSQL RDS
- Security Groups
- Bastion Host

During the first iteration, network observability and traffic auditing requirements were not yet configured.

As a result, the VPC was created without Flow Logs enabled, causing tfsec to flag the configuration.

### Impact Assessment

Without VPC Flow Logs, network visibility is significantly reduced.

Potential operational risks include:

- Difficulty troubleshooting connectivity issues
- Limited visibility into network traffic patterns
- Reduced capability for security investigations
- Lack of audit trails for compliance requirements
- Delayed incident response during network-related failures

Although the infrastructure remains functional, operational monitoring capabilities are incomplete without traffic logging.

### Resolution Approach

Enabled VPC Flow Logs within the Terraform VPC configuration.

Configured log collection to capture:

- Accepted traffic
- Rejected traffic
- Source and destination IP addresses
- Network interface activity
- Protocol and port information

The logging configuration was integrated as part of the infrastructure deployment process to ensure consistent observability across environments.

### Outcome

VPC Flow Logs successfully enabled
Network traffic visibility improved
Enhanced troubleshooting capabilities
Better support for security investigations
tfsec finding successfully remediated

### Key Takeaway

Observability should be considered a core infrastructure requirement rather than an optional enhancement. Implementing monitoring and logging during the initial infrastructure design phase significantly improves operational readiness, security visibility, and incident response capabilities.

## Challenge 4: Implementing Application Metrics Monitoring

### Objective

Implement application-level observability to monitor service health, performance, and operational behavior using Prometheus-compatible metrics.

### Problem Encountered

The sample Node.js application provided for deployment only exposed functional endpoints and did not provide any operational metrics.

The assignment required monitoring for:

- Request Rate
- Error Rate
- Request Latency

However, the application initially exposed only:

/
/health

No metrics endpoint was available for monitoring systems to scrape.

### Root Cause Analysis

The application was designed as a simple Express service and lacked instrumentation for observability.

Without application metrics:

- Request volume could not be measured
- Failed requests could not be tracked
- Response latency could not be monitored
- Capacity planning would be difficult
- Performance bottlenecks could not be identified

This created a gap between application deployment and operational monitoring requirements.

### Impact Assessment

Without application metrics, engineering teams would have limited visibility into application behavior.

Potential operational risks included:

- Delayed incident detection
- Difficulty identifying performance degradation
- Inability to monitor application health trends
- Limited data for troubleshooting production issues
- No measurable Service Level Indicators (SLIs)

### Resolution Approach

Integrated Prometheus monitoring into the Node.js application using the Prometheus client library.

Implemented:

```bash
npm install prom-client
```

## Challenge 5: Designing a Centralized Logging Solution

### Objective

Implement a centralized logging architecture capable of collecting, aggregating, and storing application, system, and access logs to improve observability, troubleshooting, and operational monitoring.

### Problem Encountered

The assignment required centralized logging for:

- Application Logs
- System Logs
- Access Logs

However, the initial implementation only focused on infrastructure provisioning and application deployment.

No centralized log aggregation mechanism existed to collect logs from multiple infrastructure components.

### Root Cause Analysis

The base application and infrastructure were designed primarily for deployment and functionality validation.

As a result:

- Application logs remained local to the container
- System logs remained on individual nodes
- Access logs were not aggregated centrally
- No unified log visibility existed

This made troubleshooting and operational monitoring difficult.

### Impact Assessment

Without centralized logging:

- Root cause analysis becomes time-consuming
- Operational visibility is limited
- Security investigations become difficult
- Log retention is inconsistent
- Correlating events across services becomes challenging

In production environments, lack of centralized logging significantly increases Mean Time To Resolution (MTTR) during incidents.

### Resolution Approach

Designed a centralized logging architecture using AWS CloudWatch as the log aggregation platform.

Implemented the following configurations:

#### Fluent Bit Configuration

Created:

```text
logging/fluent-bit-config.yaml
```

## Challenge 6: Terraform Security Hardening and Compliance Validation

### Objective

Strengthen the overall security posture of the cloud infrastructure by identifying and remediating security misconfigurations through automated Infrastructure-as-Code security scanning.

### Problem Encountered

After implementing the Terraform infrastructure, automated security validation using tfsec identified multiple security findings across networking, encryption, and infrastructure configuration.

The findings included:

- EKS Secret Encryption
- Public Subnet Exposure
- VPC Flow Logs Configuration
- KMS Key Rotation
- Infrastructure Security Best Practices

These findings highlighted areas where the infrastructure could be improved to better align with AWS security recommendations.

### Root Cause Analysis

Terraform modules are designed to provide flexible and reusable infrastructure components.

However, default configurations often prioritize usability and deployment simplicity over strict security enforcement.

As a result:

- Certain encryption features were not enabled by default
- Security recommendations required additional configuration
- Observability settings required explicit activation
- Some networking configurations triggered security scanner alerts

This is common when using community-maintained Terraform modules and requires additional hardening before production deployment.

### Impact Assessment

Without security hardening:

- Sensitive data could be insufficiently protected
- Infrastructure visibility could be reduced
- Security compliance requirements may not be fully satisfied
- Potential attack surface could increase
- Operational risk would be higher in production environments

Additionally, unresolved security findings could negatively impact future security audits and compliance reviews.

### Resolution Approach

A comprehensive review of all tfsec findings was performed.

Security improvements included:

#### Encryption Controls

Implemented:

- EKS Secret Encryption
- Encrypted RDS Storage
- AWS KMS Integration
- KMS Key Rotation

#### Network Security

Implemented:

- Private subnet deployment for RDS
- Security Group restrictions
- Subnet segmentation
- Controlled ingress and egress rules

#### Monitoring and Visibility

Implemented:

- VPC Flow Logs
- Infrastructure Metrics Collection
- Centralized Logging Configuration

#### Validation and Automation

Integrated security validation into CI/CD pipelines using:

- Terraform Validate
- Terraform Format Checks
- tfsec Security Scanning
- Trivy Container Scanning

This ensured infrastructure changes are continuously validated before deployment.

### Outcome

Security findings significantly reduced
Infrastructure security posture improved
Encryption controls strengthened
Network security enhanced
Automated security validation integrated into CI/CD
Infrastructure aligned with AWS security best practices

### Key Takeaway

Security should be treated as a continuous process rather than a final deployment step. Integrating security validation directly into Infrastructure-as-Code workflows enables early detection of misconfigurations, reduces operational risk, and promotes secure-by-default cloud deployments.

## Challenge 7: Implementing Secure Terraform State Management

### Objective

Design a reliable and production-ready Terraform state management solution that supports infrastructure consistency, prevents state corruption, and enables future team collaboration.

### Problem Encountered

Terraform relies on a state file to track all infrastructure resources under management.

During the initial implementation, Terraform was configured using the default local state backend:

```text
terraform.tfstate
```

While local state files are sufficient for learning and small-scale development environments, they introduce operational risks when managing cloud infrastructure.

As the infrastructure expanded to include:

- VPC
- EKS Cluster
- RDS PostgreSQL
- Security Groups
- Bastion Host

a more reliable state management approach became necessary.

### Root Cause Analysis

Terraform stores infrastructure state locally by default.

This approach creates several challenges:

- State file exists only on a single machine
- Risk of accidental deletion
- Difficult recovery if the machine is lost
- No protection against concurrent Terraform executions
- Limited support for team collaboration
- Increased risk of infrastructure drift

Additionally, state files often contain sensitive infrastructure metadata and resource identifiers.

Without a centralized backend, managing infrastructure changes becomes increasingly difficult as environments grow.

### Impact Assessment

Using local state in production environments can introduce significant operational risks.

Potential consequences include:

- Infrastructure state corruption
- Resource duplication
- Accidental resource destruction
- Conflicting infrastructure changes
- Lack of auditability
- Reduced disaster recovery capability

For organizations operating with multiple engineers, local state becomes a major operational bottleneck.

### Resolution Approach

Designed a remote Terraform backend architecture using AWS managed services.

#### Amazon S3 Backend

Configured Amazon S3 as the centralized state storage backend.

Benefits include:

- Highly durable storage
- Centralized state management
- State file versioning
- Backup and recovery capability
- Secure access through IAM

#### DynamoDB State Locking

Implemented DynamoDB-based state locking.

Benefits include:

- Prevents simultaneous Terraform executions
- Eliminates state corruption risks
- Supports safe infrastructure updates
- Enables collaborative workflows

### Architecture

```text
Developer
    │
    ▼
Terraform
    │
    ▼
Amazon S3
(State Storage)
    │
    ▼
DynamoDB
(State Locking)
```

### Outcome

Centralized Terraform state management implemented
Infrastructure state protected against accidental loss
State locking mechanism enabled
Improved reliability of infrastructure deployments
Better support for future team collaboration
Reduced operational risk

### Key Takeaway

Terraform state is one of the most critical assets within an Infrastructure-as-Code environment. Implementing remote state storage and state locking is essential for ensuring consistency, reliability, and scalability of cloud infrastructure deployments. Adopting these practices early significantly reduces operational risk and aligns infrastructure management with production-grade DevOps standards.

## Challenge 8: Building an End-to-End CI/CD Pipeline

### Objective

Design and implement an automated CI/CD pipeline capable of validating code quality, scanning infrastructure and containers for security issues, building Docker images, and preparing deployment artifacts for Kubernetes environments.

### Problem Encountered

The assignment required implementation of a complete CI/CD workflow capable of:

- Running automated tests
- Validating Terraform code
- Performing security scans
- Building Docker images
- Publishing container images
- Validating Kubernetes manifests

Initially, all deployment activities were manual, which increased deployment effort and risk.

### Root Cause Analysis

Without automation, every infrastructure and application change requires manual execution of:

- Terraform validation
- Security checks
- Docker builds
- Container publishing
- Kubernetes validation

This approach introduces several risks:

- Human error
- Inconsistent deployments
- Missed security validations
- Longer release cycles
- Reduced deployment reliability

A repeatable deployment process was required to ensure consistency across environments.

### Impact Assessment

Without a CI/CD pipeline:

- Code quality issues may reach production
- Infrastructure misconfigurations may go unnoticed
- Vulnerable container images may be deployed
- Deployment failures become more frequent
- Release processes become slower and less reliable

These challenges directly impact engineering productivity and operational stability.

### Resolution Approach

Implemented a GitHub Actions based CI/CD pipeline.

The pipeline was designed to automatically execute validation, security, and deployment checks whenever code changes occur.

### CI/CD Workflow Components

#### Application Testing

Configured automated execution of:

```bash
npm install
npm test
```

Ensures application dependencies and tests execute successfully before progressing through the pipeline.

---

#### Terraform Validation

Implemented:

```bash
terraform init -backend=false
terraform fmt -check
terraform validate
```

This ensures Terraform configurations remain syntactically correct and follow formatting standards.

---

#### Infrastructure Security Scanning

Integrated:

```bash
tfsec
```

to identify:

- Security misconfigurations
- Missing encryption controls
- Networking risks
- Infrastructure compliance issues

---

#### Docker Build and Publish

Configured automated Docker image creation:

```bash
docker build
docker push
```

Images are published to Docker Hub for deployment consumption.

---

#### Container Vulnerability Scanning

Integrated:

```bash
Trivy
```

to scan container images for:

- Known CVEs
- Vulnerable dependencies
- Security weaknesses

This improves overall container security posture.

---

#### Kubernetes Manifest Validation

Implemented:

```bash
kubeconform
```

to validate:

- Deployment manifests
- Service definitions
- Kubernetes resource configurations

This reduces the risk of deployment failures caused by invalid manifests.

### Outcome

End-to-end CI/CD pipeline implemented
Automated application testing enabled
Terraform validation integrated
Infrastructure security scanning implemented
Docker image build and publishing automated
Container vulnerability scanning enabled
Kubernetes manifest validation automated
Improved deployment consistency and reliability

### Key Takeaway

Automation is a foundational principle of modern DevOps practices. Implementing CI/CD pipelines not only accelerates software delivery but also improves security, consistency, and operational reliability by enforcing validation and security controls throughout the deployment lifecycle.

## Challenge 9: Implementing Container Security and Vulnerability Scanning

### Objective

Ensure that application container images are continuously scanned for known security vulnerabilities before deployment, reducing the risk of introducing insecure software into production environments.

### Problem Encountered

The assignment required vulnerability scanning for:

- Application dependencies
- Container images

Initially, the Docker build process only focused on creating and publishing images without validating their security posture.

As a result, vulnerable dependencies could potentially be packaged and deployed without detection.

### Root Cause Analysis

Container images often contain:

- Operating system packages
- Runtime libraries
- Application dependencies
- Third-party components

Many of these components may contain publicly disclosed Common Vulnerabilities and Exposures (CVEs).

Without automated scanning:

- Security vulnerabilities remain undetected
- Outdated packages may be deployed
- Compliance requirements become difficult to satisfy
- Security risks increase over time

A security validation step was required before deployment.

### Impact Assessment

Failure to scan container images can lead to:

- Deployment of vulnerable software
- Increased attack surface
- Security compliance violations
- Higher operational risk
- Delayed identification of critical vulnerabilities

In production environments, container security scanning is considered a mandatory security control.

### Resolution Approach

Integrated Trivy vulnerability scanning into the GitHub Actions CI/CD pipeline.

Implemented automated scanning after the Docker image build stage.

Pipeline configuration:

```yaml
- name: Run Trivy Vulnerability Scan
  uses: aquasecurity/trivy-action@master
  with:
    image-ref: ganesh492/8byte-devops-app:${{ github.sha }}
    format: table
    exit-code: 0
```

### Security Validation Performed

Trivy scans the container image for:

- Known CVEs
- Vulnerable operating system packages
- Dependency vulnerabilities
- Misconfigurations
- Security weaknesses

This provides visibility into security risks before deployment.

### Outcome

Automated container security scanning implemented
Vulnerability detection integrated into CI/CD
Security validation performed on every build
Improved software supply chain security
Reduced risk of deploying vulnerable images

### Verification

Container images are automatically scanned during every pipeline execution.

Scan results are available directly within the GitHub Actions workflow logs and can be reviewed before deployment decisions are made.

### Key Takeaway

Container security should be integrated into the software delivery process rather than treated as a post-deployment activity. Automating vulnerability scanning within CI/CD pipelines enables early detection of security risks and supports secure-by-default deployment practices.

## Challenge 10: Kubernetes Manifest Validation and Deployment Readiness

### Objective

Ensure Kubernetes deployment configurations are validated before deployment to reduce runtime failures, configuration errors, and production deployment risks.

### Problem Encountered

The application deployment relied on Kubernetes manifests including:

- Deployment resources
- Service resources
- Container configurations

Initially, Kubernetes YAML files were only reviewed manually before deployment.

Manual reviews can easily miss:

- Invalid API versions
- Incorrect resource definitions
- Missing mandatory fields
- Configuration inconsistencies

A validation mechanism was required to verify manifest correctness before deployment.

### Root Cause Analysis

Kubernetes is highly declarative and configuration-driven.

Even small YAML mistakes can cause:

- Deployment failures
- Pod startup issues
- Service discovery problems
- Resource creation errors

Examples include:

- Typographical mistakes
- Incorrect field names
- Invalid API versions
- Schema violations

Without automated validation, these issues are often detected only during deployment.

### Impact Assessment

Without Kubernetes manifest validation:

- Invalid configurations may reach production
- Deployment failures become more frequent
- Rollbacks may be required
- Engineering teams spend additional time troubleshooting
- Release confidence decreases

In large environments, configuration validation is considered a critical deployment safeguard.

### Resolution Approach

Integrated Kubernetes manifest validation into the GitHub Actions CI/CD pipeline using:

```bash
kubeconform
```

Pipeline configuration:

```yaml
- name: Validate Kubernetes Manifests
  run: |
    kubeconform k8s/*.yaml
```

### Validation Scope

The validation process verifies:

- Kubernetes schema compliance
- Resource definitions
- Deployment configurations
- Service configurations
- API version compatibility

This ensures manifests conform to Kubernetes standards before deployment.

### Security and Operational Benefits

Automated validation provides:

- Early detection of configuration errors
- Faster feedback during development
- Improved deployment reliability
- Reduced production deployment failures
- Increased confidence during releases

### Outcome

Kubernetes manifest validation implemented
CI/CD pipeline automatically verifies manifests
Reduced deployment risk
Improved configuration quality
Faster identification of YAML errors
Enhanced deployment reliability

### Verification

Validation executes automatically during every CI/CD pipeline run.

All Kubernetes resources located within:

```text
k8s/
```

are checked before progressing to deployment stages.

Pipeline execution successfully validates:

```text
deployment.yaml
service.yaml
```

ensuring deployment readiness.

### Key Takeaway

Infrastructure and application deployment configurations should be validated as early as possible within the software delivery lifecycle. Automated Kubernetes manifest validation improves deployment reliability, reduces operational risk, and supports consistent cloud-native deployment practices.

## Challenge 11: Securing PostgreSQL RDS and Designing a Backup Strategy

### Objective

Design a secure and resilient database architecture that protects sensitive data, minimizes exposure to public networks, and supports disaster recovery through backup mechanisms.

### Problem Encountered

The assignment required provisioning a PostgreSQL database using Amazon RDS while following cloud security best practices.

Database services are among the most critical infrastructure components because they store:

- Application data
- User information
- Configuration records
- Business-critical information

Improper database configuration can result in security vulnerabilities, data loss, and service outages.

### Root Cause Analysis

By default, cloud database services can become vulnerable when:

- Public accessibility is enabled
- Security groups are overly permissive
- Encryption is not configured
- Backup policies are missing
- Credentials are stored insecurely

These risks become more significant as environments move toward production workloads.

### Impact Assessment

Without proper database security and backup controls:

- Sensitive data may be exposed
- Unauthorized access may occur
- Data loss can become permanent
- Recovery from accidental deletion becomes difficult
- Business continuity may be affected

Databases require both preventive security controls and recovery mechanisms.

### Resolution Approach

Implemented a secure PostgreSQL RDS architecture using Terraform.

### Security Controls Implemented

#### Private Subnet Deployment

The PostgreSQL RDS instance was deployed within private subnets.

Benefits:

- No direct internet exposure
- Reduced attack surface
- Improved network isolation

---

#### Security Group Restrictions

Database access is restricted through Security Groups.

Only approved application components are permitted to communicate with the database.

Benefits:

- Controlled network access
- Principle of Least Privilege
- Reduced unauthorized connectivity

---

#### Encrypted Storage

Enabled encryption at rest for database storage.

Benefits:

- Protection of stored data
- Improved compliance posture
- Enhanced security controls

---

#### Backup Strategy

Designed an automated backup approach using Amazon RDS native backup capabilities.

Backup considerations include:

- Automated snapshots
- Point-in-time recovery
- Backup retention periods
- Disaster recovery support

This enables restoration of database state in case of:

- Accidental deletion
- Infrastructure failure
- Data corruption
- Operational mistakes

### Disaster Recovery Considerations

The backup strategy supports:

- Recovery from infrastructure failures
- Restoration of historical database states
- Reduced Recovery Time Objective (RTO)
- Reduced Recovery Point Objective (RPO)

These capabilities improve platform resilience and operational continuity.

### Outcome

PostgreSQL deployed within private subnets
Database isolated from direct internet access
Security Group restrictions implemented
Encryption at rest enabled
Backup strategy documented
Disaster recovery considerations addressed
Improved database security posture

### Verification

Database architecture validation confirmed:

- Private subnet placement
- Restricted database access
- Secure networking configuration
- Backup-ready deployment design

All controls align with AWS recommended practices for managed relational databases.

### Key Takeaway

Databases represent one of the most critical assets within any cloud environment. Security, backup, and recovery planning should be incorporated from the beginning of infrastructure design rather than added after deployment. Combining network isolation, encryption, access control, and backup strategies significantly improves platform reliability and security.
