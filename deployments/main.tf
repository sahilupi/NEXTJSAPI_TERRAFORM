provider "aws" {
  region = "ap-south-1"
}

terraform {
  backend "s3" {
    bucket                  = "nextjs.api"
    key                     = "staging.tfstate"
    region                  = "ap-south-1"
  
  }
}

module "vpc" {
  source      = "../modules/vpc"
  environment = var.environment
  name        = var.name
  vpc         = var.vpc
}


# module "elastic_cache" {
#   source          = "./../modules/elastic-cache"
#   environment     = var.environment
#   name            = var.name
#   elastic_cache   = var.elastic_cache
#   vpc_id          = module.vpc.vpc_id
#   caching_subnets = module.vpc.caching_subnets
#   vpc             = var.vpc
# }





















