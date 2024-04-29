name        = "cwj_health_solution"
region      = "ap-south-1"
environment = "staging"


vpc = {
  vpc_cidr = 10.0.0.0/16
 availability_zones  = ["ap-south-1"]
 enable_dns_support      = "true"
 enable_dns_hostnames    = "true"
 instance_tenancy        = "default"
 enable_ipv6             = "false"
 map_public_ip_on_launch = "true" #set to false then public IP will not associate
  public_subnets          = ["10.0.10.0/24", "10.0.20.0/24"].
  app_subnets             = ["10.0.30.0/24", "10.0.40.0/24"]
  database_subnets        = ["10.0.50.0/24", "10.0.60.0/24"]
  caching_subnets         = ["10.0.70.0/24", "10.0.80.0/24"]
}

rds ={
  engine = "postgres"
  engine_version = "16.1"
  instance_class = "t2.micro"
  allocated_storage = 20
  max_allocated_storage = 50
  storage_encrypted = true
  random_password_length = 20
  port = #3308
  multi_az = false
  username ="rdsdb"
  manage_master_user_password = true 
  db_subnet_group_description = "subnet group for rds"
  maintainance_window =  "Mon:00:00-Mon:03:00"
  backup_window   = "03:00-06:00"
  enabled_cloudwatch_logs_exports = ["postgresql"]
  backup_retention_period = 7
  skip_final_snapshot  = true  #false for disable final snapshot
  deletion_protection  = true  #database can't be deleted when true
  performance_insights_enabled   = false #true for enabling Performance Insights
  performance_insights_retention_period = 0
  create_monitoring_role   = true
  monitoring_role_name  = "rds-monitoring-role"
  monitoring_interval   = 0
  publicly_accessible   = true


  
  
   }












