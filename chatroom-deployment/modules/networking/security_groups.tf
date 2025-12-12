resource "aws_security_group" "alb" {
  name   = "chatroom-sg-alb"
  vpc_id = aws_vpc.main.id

  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name    = "chatroom-sg-alb"
    Tier    = "Public"
    Service = "Load-Balancer"
  })
}

resource "aws_security_group" "ecs_tasks" {
  name   = "chatroom-sg-ecs-tasks"
  vpc_id = aws_vpc.main.id

  ingress {
    description     = "HTTP traffic from ALB"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name    = "chatroom-sg-ecs-tasks"
    Tier    = "Private"
    Service = "ECS"
  })
}

resource "aws_security_group" "redis" {
  name   = "chatroom-sg-redis"
  vpc_id = aws_vpc.main.id

  ingress {
    description     = "Redis traffic from ECS tasks"
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_tasks.id]
  }

  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name    = "chatroom-sg-redis"
    Tier    = "Private"
    Service = "Cache"
  })
}

