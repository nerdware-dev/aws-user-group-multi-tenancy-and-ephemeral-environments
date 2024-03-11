variable "app_name" {
  description = "The app name this terraform plan should manage. Affects resource names."
  type        = string
}

variable "engine_version" {
  description = "The database engine version"
  type        = string
}

variable "db_max_capacity" {
  description = "The maximum capacity in ACUs"
  type        = number
}

variable "db_min_capacity" {
  description = "The minimum capacity in ACUs"
  type        = number
}

variable "subnets" {
  description = "The subnet ids of default vpc"
  type        = list(string)
}

variable "vpc_cidr" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "database_name" {
  type = string
}
