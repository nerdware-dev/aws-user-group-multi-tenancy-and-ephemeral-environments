# resource "aws_route53_record" "link" {
#   name    = var.domain_name
#   type    = "CNAME"
#   zone_id = var.zone_id
#   ttl     = "300"
#   records = [var.linked_url]
# }
