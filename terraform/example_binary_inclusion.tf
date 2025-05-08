resource "aws_instance" "my_ec2" {
  ami           = "ami-0abc123..." # Replace with a valid AMI ID
  instance_type = "t3.micro"
  user_data     = <<-EOF
              #!/bin/bash
              set -e
              yum install -y aws-cli
              aws s3 cp s3://my-bucket/my-binary /usr/local/bin/my-binary
              chmod +x /usr/local/bin/my-binary
              /usr/local/bin/my-binary --version
            EOF
  tags = {
    Name = "with-binary"
  }
}

# This example demonstrates how to include your own binary in an EC2 instance at launch time.
# - The binary is stored in S3 (s3://my-bucket/my-binary).
# - The instance downloads the binary, makes it executable, and runs it.
# - Update the AMI, bucket, and binary path as needed for your environment. 