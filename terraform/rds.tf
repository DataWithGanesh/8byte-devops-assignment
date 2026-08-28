resource "aws_db_instance" "postgres" {
  identifier = "devops-postgres"

  engine         = "postgres"
  engine_version = "16.4"

  instance_class    = "db.t3.micro"
  allocated_storage = 20

  db_name  = "appdb"
  username = var.db_username
  password = var.db_password

  publicly_accessible = false

  storage_encrypted = true

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