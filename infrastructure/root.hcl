locals {
  region = "eu-central-1"
  app    = "demo"
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}

generate "providers" {
  path      = "versions.tf"
  if_exists = "overwrite"
  contents  = <<EOF
  # PROVIDER AND BACKEND DEFINITION

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
EOF
}
