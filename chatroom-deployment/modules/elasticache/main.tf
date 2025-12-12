resource "aws_elasticache_subnet_group" "redis" {
  name       = "chatroom-redis-subnet-group"
  subnet_ids = var.private_subnet_ids
  tags = merge(var.common_tags, {
    Name    = "chatroom-redis-subnet-group"
    Service = "Cache"
  })
}

resource "aws_elasticache_replication_group" "redis" {
  description                = "Redis cluster for chatroom application"
  replication_group_id       = "chatroom-redis"
  engine                     = "redis"
  engine_version             = "7.0"
  node_type                  = "cache.t3.micro"
  num_cache_clusters         = 2
  parameter_group_name       = "default.redis7"
  port                       = 6379
  subnet_group_name          = aws_elasticache_subnet_group.redis.name
  security_group_ids         = [var.redis_security_group_id]
  automatic_failover_enabled = true
  multi_az_enabled           = true
  snapshot_retention_limit   = var.environment == "dev" ? 0 : 5
  snapshot_window            = "03:00-05:00"
  maintenance_window         = "sun:05:00-sun:07:00"
  at_rest_encryption_enabled = true
  transit_encryption_enabled = false
  auto_minor_version_upgrade = true
  tags = merge(var.common_tags, {
    Name    = "chatroom-redis-cluster"
    Service = "Cache"
    Tier    = "Private"
    Engine  = "Redis"
  })
}

