variable "app_name" {
  type        = string
  description = "Application Name"
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