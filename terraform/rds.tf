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
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-sg"
  }
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

  skip_final_snapshot       = false
  final_snapshot_identifier = "devops-postgres-final-snapshot"

  backup_retention_period = 7

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