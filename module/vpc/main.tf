resource "aws_vpc" "vpc" {
  cidr_block = var.vpc.vpc_cidr
  enable_dns_hostnames= var.vpc.enable_dns_hostnames
  instance_tenancy     = var.vpc.instance_tenancy

tags = {
     Name = "${local.name}-vpc"
}

}

# internet_gateway

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.name}-igw"
    Environment = "${var.environment}"
  }
}

#public subnets

resource "aws_subnet" "public_subnets" {
    depends_on = [
    aws_vpc.vpc,
  ]
  vpc_id     = aws_vpc.vpc.id
  count = length(var.vpc.public_subnets)
  cidr_block = element(var.vpc.public_subnets, count.index)
  availability_zone       = element(var.vpc.availability_zones, count.index)
  map_public_ip_on_launch = var.vpc.map_public_ip_on_launch

  tags = {
    Name = "${local.name}-pub-sub-${element(var.vpc.availability_zones, count.index)}"
     Environment = "${var.environment}"
}
}
# public_route_table
resource "aws_route_table" "example" {
  vpc_id = aws_vpc.example.id
    tags = {
    Name = "${local.name}-public-route-table"
    Environment ="${var.environment}"
  }
}
# public_routes

resource "aws_route" "public_routes" {
  route_table_id            = aws_route_table.testing.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ig.id
}

# public-rt-tb-association

resource "aws_route_table_association" "public_rt_tb_association" {
  count          = length(var.vpc.public_subnets)
  subnet_id      = element(aws_subnet.public_subnets.*.id, count.index)
  route_table_id = aws_route_table.public_route_table.id
}

# Elastic_ip for nat

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = element(aws_subnet.public_subnets.*.0)
   depends_on = [aws_internet_gateway.ig]


   tags = {
    Name        = "${local.name}-nat"
    Environment = "${var.environment}"
  }
}

#app subnet
resource "aws_subnet" "app_subnets" {
  depends_on = [
    aws_vpc.vpc,
  ]

  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.vpc.app_subnets)
  cidr_block              = element(var.vpc.app_subnets, count.index)
  availability_zone       = element(var.vpc.availability_zones, count.index)
  map_public_ip_on_launch = var.vpc.map_public_ip_on_launch
  tags = {
    Name        = "${local.name}-app-sub-${element(var.vpc.availability_zones, count.index)}"
    Environment = "${var.environment}"

  }
}



#app route table
resource "aws_route_table" "app_route_table" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name        = "${local.name}-app-route-table"
    Environment = "${var.environment}"
  }
}

#app-routes
resource "aws_route" "app_routes" {
  route_table_id         = aws_route_table.app_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.nat.id
}

#app-rt-tb-association
resource "aws_route_table_association" "app_rt_tb_association" {
  count          = length(var.vpc.app_subnets)
  subnet_id      = element(aws_subnet.app_subnets.*.id, count.index)
  route_table_id = aws_route_table.app_route_table.id
}

#database subnets
resource "aws_subnet" "database_subnets" {
  depends_on = [
    aws_vpc.vpc
  ]

  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.vpc.database_subnets)
  cidr_block              = element(var.vpc.database_subnets, count.index)
  availability_zone       = element(var.vpc.availability_zones, count.index)
  map_public_ip_on_launch = var.vpc.map_public_ip_on_launch
  tags = {
    Name        = "${local.name}-database-sub-${element(var.vpc.availability_zones, count.index)}"
    Environment = "${var.environment}"
  }
}

#database-route-table
resource "aws_route_table" "database_route_table" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name        = "${local.name}-database-route-table"
    Environment = "${var.environment}"
  }
}

#database_routes
resource "aws_route" "database_routes" {
  route_table_id         = aws_route_table.database_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.nat.id
}

#database-rt-tb-association
resource "aws_route_table_association" "database_rt_tb_association" {
  count          = length(var.vpc.database_subnets)
  subnet_id      = element(aws_subnet.database_subnets.*.id, count.index)
  route_table_id = aws_route_table.database_route_table.id
}


#caching subnets
resource "aws_subnet" "caching_subnets" {
  depends_on = [
    aws_vpc.vpc,
  ]

  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.vpc.caching_subnets)
  cidr_block              = element(var.vpc.caching_subnets, count.index)
  availability_zone       = element(var.vpc.availability_zones, count.index)
  map_public_ip_on_launch = var.vpc.map_public_ip_on_launch
  tags = {
    Name        = "${local.name}-caching-sub-${element(var.vpc.availability_zones, count.index)}"
    Environment = "${var.environment}"
  }
}

#caching-route-table
resource "aws_route_table" "caching_route_table" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name        = "${local.name}-caching-route-table"
    Environment = "${var.environment}"
  }
}

#caching-routes
resource "aws_route" "caching_routes" {
  route_table_id         = aws_route_table.caching_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.nat.id
}

#caching-rt-tb-association
resource "aws_route_table_association" "caching_rt_tb_association" {
  count          = length(var.vpc.caching_subnets)
  subnet_id      = element(aws_subnet.caching_subnets.*.id, count.index)
  route_table_id = aws_route_table.caching_route_table.id
}

resource "aws_security_group" "vpc-sg" {
  name        = "${local.name}-vpc-sg"
  description = "Security group to allow inbound/inbound from the vpc"
  vpc_id      = aws_vpc.vpc.id
  depends_on  = [aws_vpc.vpc]
  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }
 
  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = "true"
  }
  tags = {
    Environment = "${var.environment}"
  }
}


  
  