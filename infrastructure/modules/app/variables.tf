variable "app_name" {
  description = "The app name this terraform plan should manage. Affects resource names."
  type        = string
}

variable "app" {
  description = "The root app name this terraform plan should manage. Affects resource names."
  type        = string
}

variable "tenant" {
  description = "The tenant name this terraform plan should manage. Affects resource names."
  type        = string
}

variable "region" {
  description = "The AWS region to deploy to"
  type        = string
}

variable "base_url" {
  description = "The URL of the app"
  type        = string
}

variable "vpc_cidr" {
 type        = string
 description = "VPC CIDR value"
}

variable "public_subnet_cidrs" {
 type        = list(string)
 description = "Public Subnet CIDR values"
}

variable "private_subnet_cidrs" {
 type        = list(string)
 description = "Private Subnet CIDR values"
}

variable "availability_zones" {
 type        = list(string)
 description = "Availability Zones"
}

variable "database_engine_version" {
  type = string
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
