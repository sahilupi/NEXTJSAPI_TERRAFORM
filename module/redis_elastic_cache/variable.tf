variable "environment" {
  description = "project environment"
  type        = string
}

variable "name" {
  description = "project name"
  type        = string
}

variable "elastic_cache" {
  description = "elastic cache"
  type        = any
}

variable "caching_subnets" {
  description = "rds subnets"
  type        = any
}

variable "vpc_id" {
  description = "vpc id"
  type        = any
}

variable "vpc" {
  description = "vpc"
  type        = any
}
