resource "aws_s3_bucket" "iceberg" {
  bucket = "pixel-iceberg-tables-${var.aws_region}"
  force_destroy = true
  tags = {
    Name = "pixel-iceberg-tables"
  }
}

# Add IAM roles and policies for Flink/EMR and Nessie to access S3
# Add Nessie catalog deployment (container, EC2, or managed service)
# Add Iceberg table schema and partitioning configuration as needed 