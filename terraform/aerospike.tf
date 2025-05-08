resource "aws_launch_template" "aerospike" {
  name_prefix   = "aerospike-node-"
  image_id      = var.ami_id # TODO: Use Aerospike-optimized AMI or custom AMI
  instance_type = var.aerospike_instance_type

  # Add user_data for Aerospike installation and configuration

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "aerospike-node"
    }
  }
}

resource "aws_autoscaling_group" "aerospike" {
  name                = "aerospike-asg"
  max_size            = 16 # See sizing docs
  min_size            = 8
  desired_capacity    = 8
  vpc_zone_identifier = [aws_subnet.private_a.id]
  launch_template {
    id      = aws_launch_template.aerospike.id
    version = "$Latest"
  }
  # Add security groups, health checks, and scaling policies as needed
  tag {
    key                 = "Name"
    value               = "aerospike-node"
    propagate_at_launch = true
  }
} 