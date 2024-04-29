variable "environment" {
  description = "project environment"
  type        = string
}

variable "rds" {
  description = "rds"
  type        = any
}

variable "name" {
  description = "project name"
  type        = string
}

variable "database-subnets" {
  description = "rds subnets"
  type        = any
  
  }
  
