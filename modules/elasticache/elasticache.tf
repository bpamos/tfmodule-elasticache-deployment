


# Define the subnet group
resource "aws_elasticache_subnet_group" "ec_subnet_group" {
  name        = "ec-subnet-group"
  description = "Elasticache subnet group"
  subnet_ids  = var.vpc_subnets_ids

    tags = {
    Name = format("%s-subnet_group", var.prefix_name),
    Owner = var.owner
  }
}

resource "aws_elasticache_cluster" "example" {
  cluster_id           = format("%s-cluster", var.prefix_name)
  engine               = "redis"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis6.x"
  engine_version       = "6.0"
  port                 = 6379
  security_group_ids   = [aws_security_group.sg.id]
  subnet_group_name    = aws_elasticache_subnet_group.ec_subnet_group.name

    tags = {
    Name = format("%s-cluster", var.prefix_name),
    Owner = var.owner
  }
}