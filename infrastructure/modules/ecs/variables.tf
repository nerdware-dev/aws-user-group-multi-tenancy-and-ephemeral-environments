variable "app_name" {
  type = string
}

variable "region" {
  description = "The region to deploy to"
  type        = string
  default     = "eu-central-1"
}

variable "container_image_url" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "log_retention_in_days" {
  type    = number
  default = 7
}

# variable "alb_tls_cert_arn" {
#   description = "The ARN of the TLS certificate to use for the ALB"
# }

variable "ecs_role_arn" {
  type        = string
  description = "The ARN of the ecs role"
}

variable "ecs_settings" {
  type = object({
    health_check_path = string
    container_port    = number
    memory            = number
    cpu               = number
    desired_count     = number
    assign_public_ip  = bool
    env_vars          = map(string)
  })
}
