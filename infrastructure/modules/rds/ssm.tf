resource "aws_ssm_parameter" "rds_endpoint" {
  name  = "/${var.app_name}/DB_HOST"
  type  = "String"
  value = aws_rds_cluster.cluster.endpoint
}

resource "aws_ssm_parameter" "rds_db" {
  name  = "/${var.app_name}/DB_NAME"
  type  = "String"
  value = aws_rds_cluster.cluster.database_name
}

resource "aws_ssm_parameter" "rds_username" {
  name  = "/${var.app_name}/DB_USERNAME"
  type  = "String"
  value = aws_rds_cluster.cluster.master_username
}

resource "aws_ssm_parameter" "rds_port" {
  name  = "/${var.app_name}/DB_PORT"
  type  = "String"
  value = aws_rds_cluster.cluster.port
}

resource "aws_ssm_parameter" "rds_password" {
  name  = "/${var.app_name}/DB_PASSWORD"
  type  = "SecureString"
  value = aws_rds_cluster.cluster.master_password
}
