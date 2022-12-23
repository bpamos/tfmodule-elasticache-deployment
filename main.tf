

# # Create the Elasticache cluster
# resource "aws_elasticache_cluster" "example" {
#   cluster_id              = "my-elasticache-cluster"
#   engine                  = "memcached"
#   node_type               = "cache.t2.micro"
#   num_cache_nodes         = 1
#   port                    = 11211
#   parameter_group_name    = "default.memcached1.4"
#   security_group_ids      = [aws_security_group.example.id]
#   subnet_group_name       = aws_elasticache_subnet_group.example.name
#   apply_immediately       = true
#   auto_minor_version_upgrade = true
#   maintenance_window      = "sun:05:00-sun:09:00"
#   notification_topic_arn  = aws_sns_topic.example.arn
#   tags = {
#     Name = "my-elasticache-cluster"
#   }
# }

# # Create a security group for the Elasticache cluster
# resource "aws_security_group" "example" {
#   name        = "my-elasticache-security-group"
#   description = "Security group for my Elasticache cluster"

#   ingress {
#     from_port   = 11211
#     to_port     = 11211
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# # Create an Elasticache subnet group
# resource "aws_elasticache_subnet_group" "example" {
#   name        = "my-elasticache-subnet-group"
#   description = "Subnet group for my Elasticache cluster"
#   subnet_ids  = [aws_subnet.example1.id, aws_subnet.example2.id]
# }

# # Create the necessary subnets
# resource "aws_subnet" "example1" {
#   vpc_id            = aws_vpc.example.id
#   cidr_block        = "10.0.1.0/24"
#   availability_zone = "us-east-1a"
# }

# resource "aws_subnet" "example2" {
#   vpc_id            = aws_vpc.example.id
#   cidr_block        = "10.0.2.0/24"
#   availability_zone = "us-east-1b"
# }

# # Create a VPC for the Elasticache cluster
# resource "aws_vpc" "example" {
#   cidr_block = "10.0.0.0/16"
# }