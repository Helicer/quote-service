

# ALB Security Group to control access to the application
resource "aws_security_group" "lb" {
  name        = "${var.app_id}-alb-security-group"
  description = "Controls access to application load balancer"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol    = "tcp"
    #from_port   = var.app_port
    from_port   = 80
    #to_port     = var.app_port
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags          = {
    Name        = "${var.app_id}-alb-security-group"
  }
}




# Traffic to the ECS cluster should only come from the ALB
resource "aws_security_group" "ecs_tasks" {
  name        = "${var.app_id}-ecs-task-security-group"
  description = "Allow inbound access from the ALB only"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol        = "tcp"
    from_port       = var.app_port
    to_port         = var.app_port
    security_groups = [aws_security_group.lb.id]
  }

  egress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags          = {
    Name        = "${var.app_id}-ecs-tasks-security-group"
  }
}

resource "aws_security_group" "vpc_endpoint" {
  name = "vpc-endpoint-security-group"
  description = "VPC Endpoints require an associated security group"
  vpc_id      = aws_vpc.main.id

  # TODO: Is any of this needed?
  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  # TODO: Is any of this needed?
  egress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

//  egress {
//    protocol    = "-1"
//    from_port   = 0
//    to_port     = 0
//    cidr_blocks = ["0.0.0.0/0"]
//  }

  tags          = {
    Name        = "${var.app_id}-vpc-endpoint-security-group"
  }

}