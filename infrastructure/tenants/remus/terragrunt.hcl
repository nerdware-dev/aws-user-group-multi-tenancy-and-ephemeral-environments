locals {
  tenant   = "remus"
  app_name = "${local.tenant}-${include.root.locals.app}"

  backend = {
    # TODO: Shouldn't this be different per tenant?
    s3_bucket_name = "${include.root.locals.app}--tf-state"
    dynamodb_table = "${include.root.locals.app}--terraform-state-lock-table"
  }

  base_url = "${local.tenant}.${include.root.locals.app}.nerdware.dev"

  ecs_settings = {
    health_check_path = "/health"
    container_port    = 3000
    memory            = 8192
    cpu               = 4096
    desired_count     = 1
    assign_public_ip  = false
  }

  env_vars = {
    APP_NAME = local.app_name
    REGION   = include.root.locals.region
  }
}

include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = "../../modules//app"
}

inputs = {
  region   = include.root.locals.region
  app      = include.root.locals.app
  app_name = local.app_name
  tenant   = local.tenant
  base_url = local.base_url

  database_engine_version = "8.0.mysql_aurora.3.04.1"
  vpc_cidr                = "10.0.0.0/16"
  public_subnet_cidrs     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnet_cidrs    = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  availability_zones      = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  ecs_settings            = merge(local.ecs_settings, { env_vars : local.env_vars })
}

remote_state {
  backend  = include.root.remote_state.backend
  generate = include.root.remote_state.generate
  config = merge(
    include.root.remote_state.config,
    {
      bucket         = local.backend.s3_bucket_name
      dynamodb_table = local.backend.dynamodb_table
      key            = "terraform-${include.root.locals.app}.tfstate"
    }
  )
}
