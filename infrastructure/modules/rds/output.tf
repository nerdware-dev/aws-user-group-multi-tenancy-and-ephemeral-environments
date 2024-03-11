
output "creds" {
  value = jsondecode(
    aws_secretsmanager_secret_version.rds_secret.secret_string
  )
}
