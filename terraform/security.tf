resource "aws_security_group" "pixel_servers" {
  name        = "pixel-servers-sg"
  description = "Security group for pixel servers"
  vpc_id      = aws_vpc.main.id

  # Allow HTTP/HTTPS from load balancer
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Restrict as needed
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Restrict as needed
  }

  # Allow all egress
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "pixel-servers-sg"
  }
}

# Add additional security groups for Kafka, Flink, Aerospike, etc.
# Add NACLs and further security resources as needed 