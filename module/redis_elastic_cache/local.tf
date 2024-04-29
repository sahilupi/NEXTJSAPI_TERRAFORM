locals {

  elastic_cache_name          = format("%s-%s-%s", var.environment, var.name, "elastic-cache")
  elastic_cache_replica-count = (var.elastic_cache.elastic_cache_node_count - 1)
}