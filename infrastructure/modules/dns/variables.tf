
variable "domain_name" {
  description = "The domain name to create records in"
  type        = string
}

variable "linked_url" {
  description = "The URL to link to"
  type        = string
}

variable "zone_id" {
  description = "The ID of the hosted zone to create records in"
  type        = string
}
