


# Define the subnet group
resource "aws_elasticache_subnet_group" "ec_subnet_group" {
  name         = format("%s-subnet-group", var.prefix_name)
  #name        = "ec-subnet-group"
  description = "Elasticache subnet group"
  subnet_ids  = var.vpc_subnets_ids

    tags = {
    Name = format("%s-subnet-group", var.prefix_name),
    Owner = var.owner
  }
}

######### Cluster Mode Disabled
######### Single Shard Primary No Replication
resource "aws_elasticache_cluster" "single_shard_primary" {
  count                = var.create_standalone_ec
  cluster_id           = "standalone-cluster"
  #description          = "standalone, single primary cluster, no replica"
  engine               = "redis"
  node_type            = var.cache_node_type
  num_cache_nodes      = var.num_cache_nodes_standalone_no_replica
  parameter_group_name = "default.redis6.x"
  engine_version       = "6.0"
  port                 = 6379
  security_group_ids   = [aws_security_group.sg.id]
  subnet_group_name    = aws_elasticache_subnet_group.ec_subnet_group.name
  
  tags = {
    Name = format("%s-single-primary-cluster", var.prefix_name),
    Owner = var.owner
  }
}

######### Cluster Mode Disabled
######### Single Shard Primary and single replica
#format("%s-single-primary-single-replica-cluster", var.prefix_name)
 resource "aws_elasticache_replication_group" "cluster-mode-disabled" {
  count                         = var.create_single_shard_cluster_mode_disabled_ec
  replication_group_id          = "cluster-mode-disabled"
  description                   = "single primary, single replica, cluster mode disabled"
  automatic_failover_enabled    = true
  engine                        = "redis"
  node_type                     = var.cache_node_type
  num_cache_clusters            = var.num_cache_nodes_cluster_mode_disabled_with_replica
  multi_az_enabled              = true
  parameter_group_name          = "default.redis6.x"
  engine_version                = "6.0"
  port                          = 6379
  security_group_ids            = [aws_security_group.sg.id]
  subnet_group_name             = aws_elasticache_subnet_group.ec_subnet_group.name
  
  tags = {
    Name = format("%s-single-primary-single-replica-cluster", var.prefix_name),
    Owner = var.owner
  }
}




######### Cluster Mode enabled
resource "aws_elasticache_replication_group" "cluster-mode-enabled" {
  count                         = var.create_multi_shard_cluster_mode_enabled_ec
  replication_group_id          = "cluster-mode-enabled"
  description                   = "multi primary, multi replica, cluster mode enabled"
  automatic_failover_enabled    = true
  engine                        = "redis"
  node_type                     = var.cache_node_type
  num_node_groups               = var.num_node_groups_cluster_mode_enabled
  replicas_per_node_group       = var.replicas_per_node_group_cluster_mode_enabled
  multi_az_enabled              = true
  #parameter_group_name          = "default.redis6.x"
  engine_version                = "6.0"
  port                          = 6379
  security_group_ids            = [aws_security_group.sg.id]
  subnet_group_name             = aws_elasticache_subnet_group.ec_subnet_group.name
  
  tags = {
    Name = format("%s-multi-primary-and-multi-replica-cluster", var.prefix_name),
    Owner = var.owner
  }
}