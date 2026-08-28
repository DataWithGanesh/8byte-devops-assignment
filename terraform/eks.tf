resource "aws_security_group" "add_sg_eks" {
  name        = "additional-eks-sg"
  description = "Additional security group for EKS cluster"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "Allow HTTPS from bastion host"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  egress {
    description = "Allow outbound traffic within VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]
  }

  tags = {
    Name = "additional-eks-sg"
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = "terraform-cluster"
  kubernetes_version = "1.33"

  # Disable recommended public egress rules
  node_security_group_enable_recommended_rules = false

  # Enable EKS control plane logging
  enabled_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  addons = {
    coredns = {}

    eks-pod-identity-agent = {
      before_compute = true
    }

    kube-proxy = {}

    vpc-cni = {
      before_compute = true
    }
  }

  # Private API only
  endpoint_public_access  = false
  endpoint_private_access = true

  enable_cluster_creator_admin_permissions = true

  vpc_id                        = module.vpc.vpc_id
  subnet_ids                    = module.vpc.private_subnets
  additional_security_group_ids = [aws_security_group.add_sg_eks.id]

  eks_managed_node_groups = {
    example = {
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t3.small"]

      min_size     = 1
      desired_size = 1
      max_size     = 2

      # IMDSv2 required
      metadata_options = {
        http_endpoint = "enabled"
        http_tokens   = "required"
      }
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}