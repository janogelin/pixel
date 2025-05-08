# Example: EMR cluster for Flink (can also use standalone EC2 or AWS Kinesis Data Analytics)
resource "aws_emr_cluster" "flink" {
  name          = "pixel-flink"
  release_label = "emr-7.0.0"
  applications  = ["Flink"]
  service_role  = "arn:aws:iam::123456789012:role/EMR_DefaultRole" # TODO: Update
  ec2_attributes {
    subnet_id                         = aws_subnet.private_a.id
    emr_managed_master_security_group = aws_security_group.pixel_servers.id
    emr_managed_slave_security_group  = aws_security_group.pixel_servers.id
  }
  master_instance_type = var.flink_instance_type
  core_instance_type   = var.flink_instance_type
  core_instance_count  = 4 # See sizing docs
  # Add task nodes as needed
  # Add bootstrap actions, configurations, and steps for Flink jobs
  tags = {
    Name = "pixel-flink"
  }
}

# For standalone Flink, use aws_instance or aws_autoscaling_group resources 