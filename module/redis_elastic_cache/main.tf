#subnet group
resource "aws_elasticache_subnet_group" "elastic_cache_sub_grp" {
  name       = "${local.elastic_cache_name}-sub-grp"
  subnet_ids = var.caching_subnets

  tags = {
    Name        = "${local.elastic_cache_name}-sub-grp"
    Environment = var.environment
  }
}

#security group
resource "aws_security_group" "aws_elastic_cache_sg" {

  name        = "${local.elastic_cache_name}-sg"
  description = "Elastic cache security group"
  vpc_id      = var.vpc_id

  # ingress
  ingress {
    from_port   = "6379"
    to_port     = "6379"
    protocol    = "tcp"
    description = "vpc cidr block"
    cidr_blocks = [var.vpc.vpc_cidr]
  }

  egress {

    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = "true"
  }

  tags = {
    Name        = "${local.elastic_cache_name}-sg"
    Environment = var.environment
  }
}

#parameter_group
resource "aws_elasticache_parameter_group" "aws_elastic_cache_group" {
  name   = "${local.elastic_cache_name}-para-grp"
  family = var.elastic_cache.elastic_cache_family
}

#cloudwatch log group

resource "aws_cloudwatch_log_group" "slow_logs_elasticache_log_group" {
  name = "${local.elastic_cache_name}-slow-logs-group"
}

resource "aws_cloudwatch_log_group" "engine_logs_elasticache_log_group" {
  name = "${local.elastic_cache_name}-engine-logs-group"
}

#elastic cluster
resource "aws_elasticache_replication_group" "aws_elasticache_replication_group" {

  num_cache_clusters         = var.elastic_cache.elastic_cache_node_count
  subnet_group_name          = aws_elasticache_subnet_group.elastic_cache_sub_grp.name
  security_group_ids         = [aws_security_group.aws_elastic_cache_sg.id]
  replication_group_id       = local.elastic_cache_name
  description                = "elastic_cache replica for ${local.elastic_cache_name}"
  node_type                  = var.elastic_cache.elastic_cache_node-type
  auto_minor_version_upgrade = var.elastic_cache.auto-minor-version-upgrade
  engine                     = var.elastic_cache.elastic_cache_engine
  engine_version             = var.elastic_cache.elastic_cache_engine-version
  multi_az_enabled           = var.elastic_cache.elastic_cache_multi-az-enabled
  automatic_failover_enabled = var.elastic_cache.elastic_cache_automatic-failover-enabled
  at_rest_encryption_enabled = var.elastic_cache.elastic_cache_at_rest_encryption
  transit_encryption_enabled = var.elastic_cache.elastic_cache_transit_encryption
  snapshot_window            = var.elastic_cache.elastic_cache_snapshot-window
  snapshot_retention_limit   = var.elastic_cache.elastic_cache_snapshot-retention-limit
  parameter_group_name       = aws_elasticache_parameter_group.aws_elastic_cache_group.name
  port                       = var.elastic_cache.elastic_cache_port-number
  apply_immediately          = var.elastic_cache.elastic_cache_apply-immediately

  # Configure CloudWatch Logs
  log_delivery_configuration {
    destination      = aws_cloudwatch_log_group.engine_logs_elasticache_log_group.name
    destination_type = "cloudwatch-logs"
    log_format       = "text"
    log_type         = "engine-log"
  }
  log_delivery_configuration {
    destination      = aws_cloudwatch_log_group.slow_logs_elasticache_log_group.name
    destination_type = "cloudwatch-logs"
    log_format       = "text"
    log_type         = "slow-log"
  }

  lifecycle {
    ignore_changes = [
      engine_version,
    ]
  }

  tags = {
    Name        = "${local.elastic_cache_name}"
    Environment = var.environment
  }
}

resource "aws_elasticache_cluster" "elastic_cache_cluster_replicas" {
  count                = local.elastic_cache_replica-count
  cluster_id           = "${local.elastic_cache_name}-${count.index}"
  replication_group_id = aws_elasticache_replication_group.aws_elasticache_replication_group.id
  tags = {
    Name        = "${local.elastic_cache_name}"
    Environment = var.environment
  }

  lifecycle {
    ignore_changes = [
      engine_version,
    ]
  }
}
