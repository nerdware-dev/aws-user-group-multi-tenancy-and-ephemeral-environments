output "load_balancer_url" {
  value = aws_lb.main.dns_name
}
