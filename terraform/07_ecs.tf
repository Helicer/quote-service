

resource "aws_ecs_cluster" "main" {
  name = "${var.env_id}-cluster"
}



#data "template_file" "cb_app" {
#  template = file("./templates/ecs/cb_app.json.tpl")
#
#  vars = {
#    app_image      = var.app_image
#    app_port       = var.app_port
#    fargate_cpu    = var.fargate_cpu
#    fargate_memory = var.fargate_memory
#    aws_region     = var.aws_region
#  }
#}

resource "aws_ecs_task_definition" "app" {
  family                   = "${var.env_id}-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = <<DEFINITION
    [
      {
        "name": "${var.env_id}-container",
        "image": "${var.app_image}",
        "cpu": ${var.fargate_cpu},
        "memory": ${var.fargate_memory},
        "essential": true,
        "logConfiguration": {
          "logDriver": "awslogs",
          "options": {
            "awslogs-group": "${var.env_id}-log-group",
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
}

resource "aws_ecs_service" "main" {
  name            = "${var.env_id}-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.main.id]
    subnets          = aws_subnet.private.*.id
    #assign_public_ip = true
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.app.id
    container_name   = "${var.env_id}-container"
    container_port   = var.app_port
  }

  depends_on = [aws_alb_listener.front_end]
}
