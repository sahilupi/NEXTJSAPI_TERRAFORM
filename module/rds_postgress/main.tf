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
    cidr_blocks = ["0.0.0.0/0"]..
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
   storage_encrypted = va.rds.storage_encrypted






}



