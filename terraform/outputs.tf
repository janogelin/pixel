output "vpc_id" {
  description = "VPC ID for the pixel traffic system"
  value       = aws_vpc.main.id
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.pixel_alb.dns_name
}

output "s3_pixel_data_bucket" {
  description = "S3 bucket for pixel data"
  value       = aws_s3_bucket.pixel_data.bucket
}

output "msk_cluster_arn" {
  description = "ARN of the MSK (Kafka) cluster"
  value       = aws_msk_cluster.pixel_kafka.arn
}

# Add outputs for Flink, Iceberg, Aerospike, KMS, and other resources as needed 