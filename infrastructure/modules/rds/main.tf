resource "aws_db_subnet_group" "this" {
  name       = "${var.app_name}-sg"
  subnet_ids = var.subnets
}

resource "aws_rds_cluster" "cluster" {
  cluster_identifier                  = "${var.app_name}-rds"
  engine                              = "aurora-mysql"
  engine_mode                         = "provisioned"
  engine_version                      = var.engine_version
  database_name                       = var.database_name
  master_username                     = random_string.rds_username.result
  master_password                     = random_password.rds_password.result
  iam_database_authentication_enabled = false
  skip_final_snapshot                 = true
  final_snapshot_identifier           = true
  storage_encrypted                   = true
  kms_key_id                          = aws_kms_key.stage_secrets.arn
  db_subnet_group_name                = aws_db_subnet_group.this.name
  vpc_security_group_ids              = [aws_security_group.rds_access.id]

  serverlessv2_scaling_configuration {
    max_capacity = var.db_max_capacity
    min_capacity = var.db_min_capacity
  }
}

resource "aws_rds_cluster_instance" "cluster_instance" {
  cluster_identifier = aws_rds_cluster.cluster.id
  instance_class     = "db.serverless"
  engine             = aws_rds_cluster.cluster.engine
  engine_version     = aws_rds_cluster.cluster.engine_version
  ca_cert_identifier = "rds-ca-rsa2048-g1"
}

resource "aws_secretsmanager_secret" "rds_secret" {
  name        = "${var.app_name}-managed-db-secret-${random_string.secret_suffix.result}"
  description = "RDS credentials for accessing db"
}

resource "random_string" "secret_suffix" {
  length  = 12
  special = false
}

resource "random_string" "rds_username" {
  length  = 8
  special = false
  upper   = false
  numeric = false
}

resource "random_password" "rds_password" {
  length  = 16
  special = false
}

resource "aws_secretsmanager_secret_version" "rds_secret" {
  secret_id = aws_secretsmanager_secret.rds_secret.id
  secret_string = jsonencode({
    username             = random_string.rds_username.result
    password             = random_password.rds_password.result
    engine               = "mysql"
    host                 = aws_rds_cluster.cluster.endpoint
    port                 = 3306
    dbInstanceIdentifier = aws_rds_cluster.cluster.cluster_identifier
  })
}

resource "aws_kms_key" "stage_secrets" {
  description         = "KMS key for encrypting secrets and properties"
  enable_key_rotation = true
}
resource "aws_kms_alias" "rds_secrets_alias" {
  name          = "alias/${var.app_name}-rds-kms"
  target_key_id = aws_kms_key.stage_secrets.key_id
}

resource "aws_security_group" "rds_access" {
  name        = "RDS_Security_Group_${var.app_name}"
  description = "Allow RDS inbound traffic on port 3306 (http)"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
