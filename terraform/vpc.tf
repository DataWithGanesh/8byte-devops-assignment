module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "test-vpc-01"
  cidr = "10.0.0.0/16"

  azs = [
    "us-east-1a",
    "us-east-1b",
    "us-east-1c"
  ]

  private_subnets = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24"
  ]

  public_subnets = [
    "10.0.101.0/24",
    "10.0.102.0/24",
    "10.0.103.0/24"
  ]

  enable_nat_gateway = true
  single_nat_gateway = true
  enable_vpn_gateway = false

  # Required for Bastion + ALB
  map_public_ip_on_launch = true

  # VPC Flow Logs
  enable_flow_log = true

  create_flow_log_cloudwatch_log_group = true

  create_flow_log_cloudwatch_iam_role = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }

  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }
}