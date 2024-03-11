variable "app_name" {
  description = "The app name this terraform plan should manage. Affects resource names."
  type        = string
}

variable "dynamodb_access_policy_arn" {
  description = "The ARN of the DynamoDB table access policy to use for the app."
  type        = string
}
