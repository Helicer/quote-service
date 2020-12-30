#############################
# SECURITY GROUPS
#############################

# Security Group to control public/external access to the application load balancer (ALB)
resource "aws_security_group" "lb" {
  name        = "${var.app_id}-alb-security-group"
  description = "Permits public access to application load balancer"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol    = "tcp"
    from_port   = 80 # TODO: Add to variables
    to_port     = 80 # TODO: Add to variables
    cidr_blocks = ["0.0.0.0/0"]
  }

  # TODO: Add HTTPS 443 ingress rule

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.app_id}-alb-security-group"
  }
}



# Security group for the ECS Tasks
resource "aws_security_group" "ecs_tasks" {
  name        = "${var.app_id}-ecs-task-security-group"
  description = "Permit inbound access from the ALB only"
  vpc_id      = aws_vpc.main.id

  ingress {
    # Traffic to the ECS cluster should only come from the ALB
    protocol        = "tcp"
    from_port       = var.app_port
    to_port         = var.app_port
    security_groups = [aws_security_group.lb.id]
  }

  # TODO: Is this needed? for pulling down ECR images thru VPC Endpoint
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    # Traffic to the ECS cluster should only come from the ALB
    protocol        = "tcp"
    from_port       = 0
    to_port         = 0
    security_groups = [aws_security_group.lb.id]
  }

  tags = {
    Name = "${var.app_id}-ecs-tasks-security-group"
  }
}

# Security group for the ECR VPC Endpoint
resource "aws_security_group" "ecr_vpc_endpoint" {
  name        = "${var.app_id}-ecr-vpc-endpoint-security-group"
  description = "Allow ECS Fargate Tasks to access VPC Endpoints"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol        = "tcp"
    from_port       = 443
    to_port         = 443
    security_groups = [aws_security_group.ecs_tasks.id]
  }

  # TODO: Should this be restricted?
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.app_id}-ecr-vpc-endpoint-security-group"
  }

}