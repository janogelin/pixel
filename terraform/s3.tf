resource "aws_s3_bucket" "pixel_data" {
  bucket = "pixel-data-${var.aws_region}"
  force_destroy = true
  tags = {
    Name = "pixel-data"
  }
}

resource "aws_s3_bucket_versioning" "pixel_data" {
  bucket = aws_s3_bucket.pixel_data.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "pixel_data" {
  bucket = aws_s3_bucket.pixel_data.id
  rule {
    id     = "expire-old-data"
    status = "Enabled"
    expiration {
      days = 30
    }
  }
}

# Add prefix structure and additional buckets as needed for analytics, logs, etc. 