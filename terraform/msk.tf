module "msk" {
  source                = "./modules/msk"
  cluster_name          = "pixel-msk"
  kafka_version         = "3.6.0"
  number_of_broker_nodes = 6 # See sizing docs
  broker_instance_type  = "kafka.m7g.large" # Update as needed
  subnet_ids            = [aws_subnet.private_a.id]
  security_groups       = [aws_security_group.pixel_servers.id]
  kms_key_arn           = aws_kms_key.kafka.arn
  tags = {
    Name = "pixel-msk"
  }
}

output "msk_cluster_arn" {
  value = module.msk.msk_cluster_arn
}

output "msk_bootstrap_brokers" {
  value = module.msk.bootstrap_brokers
}

# Add configuration for monitoring, logging, and additional subnets as needed 