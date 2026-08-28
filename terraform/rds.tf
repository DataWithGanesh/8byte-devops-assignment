resource "aws_db_subnet_group" "postgres" {
  name       = "postgres-subnet-group"
  subnet_ids = module.vpc.private_subnets

  tags = {
    Name = "postgres-subnet-group"
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Security Group for PostgreSQL"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow PostgreSQL access from VPC"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    description = "Allow outbound traffic within VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]
  }

  tags = {
    Name = "rds-sg"
  }
}

resource "aws_kms_key" "rds" {
  description             = "KMS key for RDS Performance Insights"
  deletion_window_in_days = 7

  enable_key_rotation = true
}

resource "aws_db_instance" "postgres" {
  identifier     = "devops-postgres"
  engine         = "postgres"
  engine_version = "16.4"

  instance_class    = "db.t3.micro"
  allocated_storage = 20

  db_name  = "appdb"
  username = var.db_username
  password = var.db_password

  publicly_accessible = false
  storage_encrypted   = true

  performance_insights_enabled    = true
  performance_insights_kms_key_id = aws_kms_key.rds.arn

  iam_database_authentication_enabled = true

  backup_retention_period = 7

  skip_final_snapshot       = false
  final_snapshot_identifier = "devops-postgres-final-snapshot"

  deletion_protection = true

  db_subnet_group_name = aws_db_subnet_group.postgres.name

  vpc_security_group_ids = [
    aws_security_group.rds_sg.id
  ]

  tags = {
    Name        = "devops-postgres"
    Environment = "dev"
    Terraform   = "true"
  }
}