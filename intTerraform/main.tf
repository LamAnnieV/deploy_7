provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = "us-east-1"

}

# Cluster
resource "aws_ecs_cluster" "aws-ecs-cluster" {
  name = "D7-bankapp-cluster"
  tags = {
    Name = "D7-bankapp-ecs"
  }
}

resource "aws_cloudwatch_log_group" "log-group" {
  name = "/ecs/bank-logs"

  tags = {
    Application = "bank-app"
  }
}

# Task Definition

resource "aws_ecs_task_definition" "aws-ecs-task" {
  family = "D7-bankapp-task"

  container_definitions = <<EOF
  [
  {
      "name": "D7-bankapp-container",
      "image": "annievlam/bankapp:latest",
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/bank-logs",
          "awslogs-region": "us-east-1",
          "awslogs-stream-prefix": "ecs"
        }
      },
      "portMappings": [
        {
          "containerPort": 8000
        }
      ]
    }
  ]
  EOF

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = "1024"
  cpu                      = "512"
  execution_role_arn       = "arn:aws:iam::952166878386:role/ecsTaskExecRole"
  task_role_arn            = "arn:aws:iam::952166878386:role/ecsTaskExecRole"

}

# ECS Service
resource "aws_ecs_service" "aws-ecs-service" {
  name                 = "D7-bankapp-ecs-service"
  cluster              = aws_ecs_cluster.aws-ecs-cluster.id
  task_definition      = aws_ecs_task_definition.aws-ecs-task.arn
  launch_type          = "FARGATE"
  scheduling_strategy  = "REPLICA"
  desired_count        = 2
  force_new_deployment = true

  network_configuration {
    subnets = [
      aws_subnet.private_a.id,
      aws_subnet.private_b.id
    ]
    assign_public_ip = false
    security_groups  = [aws_security_group.ingress_app.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.bank-app.arn
    container_name   = "D7-bankapp-container"
    container_port   = 8000
  }

}
