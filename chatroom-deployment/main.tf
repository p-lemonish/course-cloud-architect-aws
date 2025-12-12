terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.92"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project   = "Chatroom"
      ManagedBy = "Terraform"
    }
  }
}

locals {
  common_tags = {
    Course         = "cloud_architectures_AWS-ICI010AS3AE_3003"
    Implementation = "Chatroom-IaC"
    Task           = "chatroom-iac-deployment"
    Student        = "patrik"
    DeploymentType = "Terraform"
    Region         = var.aws_region
  }
  timestamp = formatdate("YYYYMMDD-hhmm", timestamp())
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_caller_identity" "current" {}

module "networking" {
  source             = "./modules/networking"
  vpc_cidr           = var.vpc_cidr
  availability_zones = slice(data.aws_availability_zones.available.names, 0, 2)
  environment        = var.environment
  common_tags        = local.common_tags
}

module "ecr" {
  source      = "./modules/ecr"
  common_tags = local.common_tags
}

module "elasticache" {
  source                  = "./modules/elasticache"
  private_subnet_ids      = module.networking.private_subnet_ids
  redis_security_group_id = module.networking.redis_security_group_id
  environment             = var.environment
  common_tags             = local.common_tags
}

module "alb" {
  source                = "./modules/alb"
  vpc_id                = module.networking.vpc_id
  public_subnet_ids     = module.networking.public_subnet_ids
  alb_security_group_id = module.networking.alb_security_group_id
  environment           = var.environment
  common_tags           = local.common_tags
}

module "s3_cloudfront" {
  source       = "./modules/s3_cloudfront"
  account_id   = data.aws_caller_identity.current.account_id
  alb_dns_name = module.alb.alb_dns_name
  environment  = var.environment
  common_tags  = local.common_tags
  timestamp    = local.timestamp
}

module "ecs" {
  source                = "./modules/ecs"
  ecr_repository_url    = module.ecr.backend_repository_url
  private_subnet_ids    = module.networking.private_subnet_ids
  ecs_security_group_id = module.networking.ecs_security_group_id
  target_group_arn      = module.alb.target_group_arn
  alb_listener_arn      = module.alb.listener_arn
  redis_endpoint        = "${module.elasticache.redis_endpoint}:${module.elasticache.redis_port}"
  cloudfront_domain     = "https://${module.s3_cloudfront.cloudfront_domain_name}"
  aws_region            = var.aws_region
  environment           = var.environment
  common_tags           = local.common_tags
}
