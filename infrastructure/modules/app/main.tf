locals {
  domain = "demo.nerdware.dev"
}

module "vpc" {
  source               = "../vpc"
  app_name             = var.app_name
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

data "aws_route53_zone" "this" {
  name = local.domain
}

module "frontend" {
  source                  = "../frontend"
  app_name                = var.app_name
  aliases                 = [var.base_url]
  cloudfront_ssl_cert_arn = module.dns_frontend.cert_arn
  delete_on_destroy       = true
}

module "dns_frontend" {
  source      = "../dns"
  domain_name = var.base_url
  zone_id     = data.aws_route53_zone.this.zone_id
  linked_url  = module.frontend.cloudfront_url
  providers = {
    aws.us_east_1 = aws.us_east_1
  }
}

module "dynamodb_table" {
  source         = "../dynamodb" // path to the module
  app_name       = var.app_name
  name           = "${var.app_name}-table"
  read_capacity  = 10
  write_capacity = 10
  hash_key       = "Tenant"
  attributes = [
    {
      name = "Tenant"
      type = "S"
    }
  ]
}

module "backend" {
  source              = "../ecs"
  app_name            = var.app_name
  region              = var.region
  container_image_url = module.ecr.repository_url
  vpc_cidr            = var.vpc_cidr
  private_subnet_ids  = module.vpc.private_subnets_ids
  public_subnet_ids   = module.vpc.public_subnets_ids
  vpc_id              = module.vpc.vpc_id
  alb_tls_cert_arn    = module.dns_backend.regional_cert_arn
  ecs_role_arn        = module.iam.ecs_role_arn
  ecs_settings        = var.ecs_settings
}



module "dns_backend" {
  source      = "../dns"
  domain_name = "api.${var.base_url}"
  zone_id     = data.aws_route53_zone.this.zone_id
  linked_url  = module.backend.load_balancer_url
  providers = {
    aws.us_east_1 = aws.us_east_1
  }
}

module "ecr" {
  source              = "../ecr"
  ecr_repository_name = "${var.app_name}-ecr"
}

module "iam" {
  source                     = "../iam"
  app_name                   = var.app_name
  dynamodb_access_policy_arn = module.dynamodb_table.dynamodb_access_policy_arn
}
