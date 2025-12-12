resource "aws_lb" "main" {
  name                       = "chatroom-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [var.alb_security_group_id]
  subnets                    = var.public_subnet_ids
  enable_deletion_protection = false
  enable_http2               = true
  tags = merge(var.common_tags, {
    Name    = "chatroom-alb"
    Tier    = "Public"
    Service = "Load-Balancer"
  })
}

resource "aws_lb_target_group" "backend" {
  name        = "chatroom-backend-tg"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  health_check {
    enabled             = true
    path                = "/health"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }
  deregistration_delay = 30
  stickiness {
    type            = "lb_cookie"
    cookie_duration = 86400
    enabled         = true
  }
  tags = merge(var.common_tags, {
    Name    = "chatroom-backend-tg"
    Service = "Load-Balancer"
  })
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend.arn
  }
  tags = merge(var.common_tags, {
    Name    = "chatroom-alb-listener-http"
    Service = "Load-Balancer"
  })
}

