data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_ecs_cluster" "main" {
  name = "chatroom-ecs-cluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
  tags = merge(var.common_tags, {
    Name    = "chatroom-ecs-cluster"
    Service = "Container-Orchestration"
  })
}

resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/chatroom-backend"
  retention_in_days = 7
  tags = merge(var.common_tags, {
    Name    = "chatroom-backend-logs"
    Service = "Logging"
  })
}

resource "aws_ecs_task_definition" "backend" {
  family                   = "chatroom-backend"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([{
    name      = "chatroom-backend"
    image     = "${var.ecr_repository_url}:latest"
    essential = true
    portMappings = [{
      containerPort = 8080
      hostPort      = 8080
      protocol      = "tcp"
    }]
    environment = [
      {
        name  = "PORT"
        value = "8080"
      },
      {
        name  = "ALLOWED_ORIGIN"
        value = var.cloudfront_domain
      },
      {
        name  = "REDIS_URL"
        value = var.redis_endpoint
      }
    ]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = aws_cloudwatch_log_group.ecs_logs.name
        "awslogs-region"        = var.aws_region
        "awslogs-stream-prefix" = "backend"
      }
    }
    healthCheck = {
      command     = ["CMD-SHELL", "curl -f http://localhost:8080/health || exit 1"]
      interval    = 30
      timeout     = 5
      retries     = 3
      startPeriod = 60
    }
  }])
  tags = merge(var.common_tags, {
    Name    = "chatroom-backend-task"
    Service = "ECS"
  })
}

resource "aws_ecs_service" "backend" {
  name            = "chatroom-backend-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.backend.arn
  desired_count   = 2
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [var.ecs_security_group_id]
    assign_public_ip = false
  }
  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "chatroom-backend"
    container_port   = 8080
  }
  depends_on = [var.alb_listener_arn]
  tags = merge(var.common_tags, {
    Name    = "chatroom-backend-service"
    Service = "ECS"
  })
}
