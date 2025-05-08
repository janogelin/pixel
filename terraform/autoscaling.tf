resource "aws_launch_template" "pixel" {
  name_prefix   = "pixel-server-"
  image_id      = var.ami_id # TODO: Update with valid AMI
  instance_type = var.pixel_instance_type

  # Add user_data, IAM roles, and other configuration as needed

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "pixel-server"
    }
  }
}

resource "aws_autoscaling_group" "pixel" {
  name                      = "pixel-asg"
  max_size                  = 10
  min_size                  = 2
  desired_capacity          = 2
  vpc_zone_identifier       = [aws_subnet.private_a.id]
  launch_template {
    id      = aws_launch_template.pixel.id
    version = "$Latest"
  }
  target_group_arns         = [aws_lb_target_group.pixel_tg.arn]

  # Add scaling policies, scheduled actions, and notifications as needed

  tag {
    key                 = "Name"
    value               = "pixel-server"
    propagate_at_launch = true
  }
} 