variable "app_name" {
  description = "The app name this terraform plan should manage. Affects resource names."
  type        = string
}

variable "aliases" {
  type        = list(string)
  description = "Extra CNAMEs (alternate domain names), if any, for this distribution."
}

variable "error_ttl" {
  type        = number
  default     = 10
  description = "The minimum amount of time, in seconds, that you want CloudFront to cache the HTTP status code specified in ErrorCode"
}

variable "geo_restriction" {
  description = "The restriction configuration for this distribution (geo_restrictions)"
  type        = any
  default     = {}
}

variable "log_retention" {
  type        = number
  default     = 7
  description = "Number of days after which Amazon S3 will delete CloudFront access logs"
}

variable "response_headers_policy_id" {
  type        = string
  description = "The identifier for a response headers policy"
  default     = ""
}

variable "allowed_methods" {
  type        = list(string)
  default     = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
  description = "List of allowed methods (e.g. ` GET, PUT, POST, DELETE, HEAD`) for AWS CloudFront"
}

variable "cached_methods" {
  type        = list(string)
  default     = ["GET", "HEAD"]
  description = "List of cached methods (e.g. ` GET, PUT, POST, DELETE, HEAD`)"
}

variable "default_ttl" {
  type        = number
  default     = 3600
  description = "Default amount of time (in seconds) that an object is in a CloudFront cache"
}

variable "min_ttl" {
  type        = number
  default     = 0
  description = "Minimum amount of time that you want objects to stay in CloudFront caches"
}

variable "max_ttl" {
  type        = number
  default     = 86400
  description = "Maximum amount of time (in seconds) that an object is in a CloudFront cache"
}

variable "cloudfront_ssl_cert_arn" {
  type        = string
  description = "ACM certificate Arn."
}

variable "delete_on_destroy" {
  type        = bool
  description = "Whether to delete all objects in the bucket when destroying this resource"
  default     = false
}

variable "password_protection" {
  description = "Protect CloudFront distribution with Basic Authentication"
  type        = bool
  default     = false
}
