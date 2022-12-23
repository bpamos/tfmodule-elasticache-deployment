##### Explain


########### VPC Module
#### create a brand new VPC, use its outputs in future modules
#### If you already have an existing VPC, comment out and
#### enter your VPC params in the future modules
module "vpc" {
    source             = "./modules/vpc"
    aws_creds          = var.aws_creds
    owner              = var.owner
    region             = var.region
    prefix_name        = var.prefix_name
    vpc_cidr           = var.vpc_cidr
    subnet_cidr_blocks = var.subnet_cidr_blocks
    subnet_azs         = var.subnet_azs
}

### VPC outputs 
### Outputs from VPC outputs.tf, 
### must output here to use in future modules)
output "subnet-ids" {
  value = module.vpc.subnet-ids
}

output "vpc-id" {
  value = module.vpc.vpc-id
}

output "vpc_name" {
  description = "get the VPC Name tag"
  value = module.vpc.vpc-name
}

output "route-table-id" {
  description = "route table id"
  value = module.vpc.route-table-id
}


########### ElastiCache Module
#### Create ElastiCache Cluster
module "elasticache" {
    source             = "./modules/elasticache"
    owner              = var.owner
    prefix_name        = var.prefix_name
    vpc_cidr           = var.vpc_cidr
    allow-public-ssh   = var.allow-public-ssh
    ### vars pulled from previous modules
    ## from vpc module outputs 
    vpc_name           = module.vpc.vpc-name
    vpc_subnets_ids    = module.vpc.subnet-ids
    vpc_id             = module.vpc.vpc-id

    depends_on = [module.vpc]
}

output "vpc_security_group_ids" {
  value = module.elasticache.vpc_security_group_ids
}

# #### Node Outputs to use in future modules
# output "re-data-node-eips1" {
#   value = module.nodes1.re-data-node-eips
# }

########### Test Node Module
#### Create Test nodes
#### Ansible playbooks configure Test node with Redis and Memtier
module "tester-nodes" {
    source             = "./modules/tester-nodes"
    owner              = var.owner
    region             = var.region
    subnet_azs         = var.subnet_azs
    ssh_key_name       = var.ssh_key_name
    ssh_key_path       = var.ssh_key_path
    test_instance_type = var.test_instance_type
    test-node-count    = var.test-node-count
    ### vars updated from user RE Cluster VPC
    vpc_name           = module.vpc.vpc-name
    vpc_subnets_ids    = module.vpc.subnet-ids
    vpc_security_group_ids = module.elasticache.vpc_security_group_ids

}

# output "test-node-eips" {
#   value = module.tester-nodes.test-node-eips
# }