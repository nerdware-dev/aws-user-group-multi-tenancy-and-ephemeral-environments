output "cert_arn" {
  value = aws_acm_certificate.cert.arn
}

output "regional_cert_arn" {
  value = aws_acm_certificate.cert_in_current_region.arn
}
