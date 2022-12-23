


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
  cluster_id           = "standalone-cluster"
  #description          = "standalone, single primary cluster, no replica"
  engine               = "redis"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
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
  replication_group_id          = "cluster-mode-disabled"
  description                   = "single primary, single replica, cluster mode disabled"
  automatic_failover_enabled    = true
  engine                        = "redis"
  node_type                     = "cache.t2.micro"
  num_cache_clusters            = 2
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
  replication_group_id          = "cluster-mode-enabled"
  description                   = "multi primary, multi replica, cluster mode enabled"
  automatic_failover_enabled    = true
  engine                        = "redis"
  node_type                     = "cache.t2.micro"
  num_node_groups               = 2
  replicas_per_node_group       = 2
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