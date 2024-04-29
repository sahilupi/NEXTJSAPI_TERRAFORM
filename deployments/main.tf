provider "aws" {
  region = "your_aws_region"
}
module "rds" {
  source = "./../modules/rds"

  name             = var.name
  rds              = var.rds
  environment      = var.environment
  vpc_id           = module.vpc.vpc_id
  database-subnets = module.vpc.database_subnets
}


module "elastic_cache" {
  source          = "./../modules/elastic-cache"
  environment     = var.environment
  name            = var.name
  elastic_cache   = var.elastic_cache
  vpc_id          = module.vpc.vpc_id
  caching_subnets = module.vpc.caching_subnets
  vpc             = var.vpc
}





















