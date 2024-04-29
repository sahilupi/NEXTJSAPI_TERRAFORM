locals {

  name_database = format("%s-%s-%s", var.environment, var.name, "rds")
}

