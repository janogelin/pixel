output "msk_cluster_arn" {
  description = "ARN of the MSK cluster"
  value       = aws_msk_cluster.this.arn
}

output "bootstrap_brokers" {
  description = "Bootstrap brokers string for clients"
  value       = aws_msk_cluster.this.bootstrap_brokers
} 