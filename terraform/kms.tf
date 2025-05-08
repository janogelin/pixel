resource "aws_kms_key" "s3" {
  description = "KMS key for S3 bucket encryption"
  enable_key_rotation = true
}

resource "aws_kms_key" "kafka" {
  description = "KMS key for Kafka (MSK) encryption"
  enable_key_rotation = true
}

resource "aws_kms_key" "general" {
  description = "General KMS key for application and TLS/JWT encryption"
  enable_key_rotation = true
}

# Add key policies, aliases, and grants as needed 