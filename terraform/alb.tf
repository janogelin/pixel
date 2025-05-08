resource "aws_lb" "pixel_alb" {
  name               = "pixel-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.pixel_servers.id]
  subnets            = [aws_subnet.public_a.id]

  tags = {
    Name = "pixel-alb"
  }
}

resource "aws_lb_target_group" "pixel_tg" {
  name     = "pixel-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/health"
    protocol            = "HTTP"
    matcher             = "200-299"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "pixel-tg"
  }
}

# Add listeners and SSL certificate configuration as needed 