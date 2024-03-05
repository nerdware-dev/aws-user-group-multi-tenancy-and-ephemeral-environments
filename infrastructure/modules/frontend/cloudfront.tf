resource "aws_cloudfront_origin_access_identity" "this" {
  comment = "origin_access_identity"
}

resource "aws_cloudfront_distribution" "this" {

  origin {
    domain_name = aws_s3_bucket.origin.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.origin.bucket_regional_domain_name
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.this.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = var.aliases[0]
  default_root_object = "index.html"

  aliases = var.aliases

  default_cache_behavior {
    allowed_methods            = var.allowed_methods
    cached_methods             = var.cached_methods
    target_origin_id           = aws_s3_bucket.origin.bucket_regional_domain_name
    response_headers_policy_id = var.response_headers_policy_id
    compress                   = true

    # we don't need forward query strings or cookies to the origin
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    dynamic "lambda_function_association" {
      for_each = var.password_protection ? [1] : []
      content {
        event_type   = "viewer-request"
        include_body = false
        lambda_arn   = "${aws_lambda_function.basic_auth[0].arn}:${aws_lambda_function.basic_auth[0].version}"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = var.min_ttl
    default_ttl            = var.default_ttl
    max_ttl                = var.max_ttl
  }

  custom_error_response {
    error_code            = 403
    error_caching_min_ttl = var.error_ttl
    response_code         = 200
    response_page_path    = "/index.html"
  }

  custom_error_response {
    error_code            = 404
    error_caching_min_ttl = var.error_ttl
    response_code         = 200
    response_page_path    = "/index.html"
  }

  # add if needed ordered_cache_behavior {}

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = var.cloudfront_ssl_cert_arn
    ssl_support_method  = "sni-only"
  }
}
