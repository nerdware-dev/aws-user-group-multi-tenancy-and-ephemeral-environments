variable "app_name" {
  description = "The app name this terraform plan should manage. Affects resource names."
  type        = string
}

variable "name" {
  description = "The name of the table, this needs to be unique within a region."
  type        = string
}

variable "read_capacity" {
  description = "The maximum number of read operations per second."
  type        = number
  default     = 5
}

variable "write_capacity" {
  description = "The maximum number of write operations per second."
  type        = number
  default     = 5
}

variable "hash_key" {
  description = "The attribute to use as the hash (partition) key. Must also be defined as an attribute."
  type        = string
}

variable "range_key" {
  description = "The attribute to use as the range (sort) key. Must also be defined as an attribute."
  type        = string
  default     = null
}

variable "attributes" {
  description = "A list of attribute definitions."
  type = list(object({
    name = string
    type = string
  }))
}
