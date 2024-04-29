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
  public_subnets          = ["10.0.10.0/24", "10.0.20.0/24"]
  app_subnets             = ["10.0.30.0/24", "10.0.40.0/24"]
  database_subnets        = ["10.0.50.0/24", "10.0.60.0/24"]
  caching_subnets         = ["10.0.70.0/24", "10.0.80.0/24"]

}












