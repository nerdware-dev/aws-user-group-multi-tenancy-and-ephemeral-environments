provider "aws" {
  region = "eu-central-1"

  default_tags {
    tags = {
      Application = "${var.app}"
      Tenant      = "${var.tenant}"
      ManagedBy   = "Terraform"
    }
  }
}

# TODO: Why us-east-1?
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}
