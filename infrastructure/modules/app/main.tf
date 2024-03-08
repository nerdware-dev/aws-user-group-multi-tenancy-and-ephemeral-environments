### VPC

module "vpc" {
  source    = "../vpc"
  app_name  = var.app_name
  vpc_cidr  = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones = var.availability_zones
}


### Route53

data "aws_route53_zone" "frontend_zone" {
  name = "demo.nerdware.dev"
}

### Frontend

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
  zone_id     = data.aws_route53_zone.frontend_zone.zone_id
  linked_url  = module.frontend.cloudfront_url
  providers = {
    aws.us_east_1 = aws.us_east_1
  }
}

#### Backend

# module "database" {
#   app_name        = var.app_name
#   source          = "../rds"
#   db_max_capacity = 10
#   db_min_capacity = 0.5
#   subnets         = module.vpc.private_subnets_ids
#   vpc_cidr        = var.vpc_cidr
#   vpc_id          = module.vpc.vpc_id
#   database_name   = "orgadmin"
#   engine_version  = var.database_engine_version
# }

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

data "aws_route53_zone" "backend_zone" {
  name = "demo.nerdware.dev"
}

module "dns_backend" {
  source      = "../dns"
  domain_name = "api.${var.base_url}"
  zone_id     = data.aws_route53_zone.backend_zone.zone_id
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
  source = "../iam"
  app_name = var.app_name
}