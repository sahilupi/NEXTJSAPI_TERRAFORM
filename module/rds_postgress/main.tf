resource "aws_db_subnet_group" "default" {
  name       = "${local.name_database}-subnet-gp"
  subnet_ids = [aws_subnet.frontend.id, aws_subnet.backend.id]

  tags = {
    Name        = "${local.name_database}-subnet-group"
    Environment = var.environment
  }
}
resource "aws_security_group" "database-sg" {
  name        = "${local.name_database}-sg"
  description = "RDS security group"
  vpc_id      = var.vpc_id

}

ingress {

    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"].
    self        = "false"
  }

  egress {

    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    self        = "false"
  }
    tags = {
    Name        = "${local.name_database}-sg"
    Environment = var.environment
  }
resource "aws_db_instance" "database" {
  identifier =  "${local.name_database}-server"
   engine = var.rds.engine
   engine_version = var.rds.engine
   instance_class = var.rds.instance_class
   allocated_storage = var.rds.allocated_storage
   max_allocated_storage = var.rds.max_allocated_storage
   storage_encrypted = var.rds.storage_encrypted
   port = var.rds.port
   username   = var.rds.username
   manage_master_user_password = var.rds.manage_master_user_password
   multi_az = var.rds.multi_az
   vpc_security_group_ids = [aws_security_group.database-sg.id]
   enabled_cloudwatch_logs_exports = var.rds.enabled_cloudwatch_logs_exports
   backup_retention_period   = var.rds.backup_retention_period
   backup_window = var.rds.backup_window
   maintenance_window = var.rds.maintenance_window
   skip_final_snapshot = var.rds.skip_final_snapshot
  deletion_protection = var.rds.deletion_protection
  performance_insights_enabled = var.rds.performance_insights_enabled
  performance_insights_retention_period = var.rds.performance_insights_retention_period
  monitoring_interval  = var.rds.mnitoring_interval
  publicly_accessible  = var.rds.publicly_accessible

  
  tags = {
    Name        = "${local.name_database}"
    Environment = var.environment
  }
}


  

  











