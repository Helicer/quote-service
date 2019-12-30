#############################
# ELASTIC CONTAINER SERVICE (ECS)
#############################


# App ECS cluster, which contains ECS Services and ECS Tasks
resource "aws_ecs_cluster" "main" {
  name = "${var.app_id}-cluster"
}

# ECS Task which runs the app container (pulled from AWS ECR)
resource "aws_ecs_task_definition" "app" {
  # Task name
  family                   = "${var.app_id}-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = <<DEFINITION
    [
      {
        "name": "${var.app_id}-container",
        "image": "${var.app_image}",
        "cpu": ${var.fargate_cpu},
        "memory": ${var.fargate_memory},
        "essential": true,
        "logConfiguration": {
          "logDriver": "awslogs",
          "options": {
            "awslogs-group": "ecs/${var.app_id}-log-group",
            "awslogs-region": "${var.aws_region}",
            "awslogs-stream-prefix": "ecs"
          }
        },
        "portMappings": [
            {
              "containerPort": ${var.app_port},
              "hostPort": ${var.app_port}
            }
          ]
      }
    ]
    DEFINITION

  # TODO: Container Definition Factor log information into TF variables
}

# AWS ECS Service which runs instances of the app as ECS Tasks
resource "aws_ecs_service" "main" {
  name            = "${var.app_id}-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  # Prevents ECS from terminating tasks which are marked failed by ALB health check when starting up
  # NOTE: Using 4 x ALB health check test interval + time it takes for app to start
  health_check_grace_period_seconds = 180

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = aws_subnet.private.*.id
    #assign_public_ip = true
    assign_public_ip = false
  }

  # Registers the ECS Tasks & Service with the Application Load Balancer target group
  load_balancer {
    target_group_arn = aws_alb_target_group.app.id
    container_name   = "${var.app_id}-container"
    container_port   = var.app_port
  }

  depends_on = [aws_alb_listener.front_end]
}
