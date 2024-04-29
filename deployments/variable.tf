# variable "region" {
#   description = "project aws region"
#   type        = string
# }

variable "environment" {
  description = "project environment"
  type        = string
}

variable "name" {
  description = "project name"
  type        = string
}

variable "vpc" {
  description = "vpc"
  type        = any
}
