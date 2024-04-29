output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "vpc_cidr_block" {
  value = aws_vpc.vpc.cidr_block
}

output "vpc_name" {
  value = aws_vpc.vpc.arn
}

#public subnet
output "public_subnets" {
  value = aws_subnet.public_subnets.*.id
}
#app subnet
output "app_subnets" {
  value = aws_subnet.app_subnets.*.id
}
output "app_subnet_0" {
  value = aws_subnet.app_subnets.0.id
}

output "app_subnet_1" {
  value = aws_subnet.app_subnets.1.id
}

# database subnet
output "database_subnets" {
  value = aws_subnet.database_subnets.*.id
}
output "database_subnet_0" {
  value = aws_subnet.database_subnets.0.id
}

output "database_subnet_1" {
  value = aws_subnet.database_subnets.1.id
}
#caching subnet

output "caching_subnets" {
  value = aws_subnet.caching_subnets.*.id
}
output "caching_subnets_0" {
  value = aws_subnet.caching_subnets.0.id
}

output "caching_subnets_1" {
  value = aws_subnet.database_subnets.1.id
}



