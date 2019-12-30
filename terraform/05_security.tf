#############################
# SECURITY
#############################

# Security Group to control public access to the application load balancer (ALB)
resource "aws_security_group" "lb" {
  name        = "${var.app_id}-alb-security-group"
  description = "Controls access to application load balancer"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol    = "tcp"
    from_port   = 80 # TODO: Add to variables
    to_port     = 80 # TODO: Add to variables
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



# Security group for the ECS Tasks
resource "aws_security_group" "ecs_tasks" {
  name        = "${var.app_id}-ecs-task-security-group"
  description = "Allow inbound access from the ALB only"
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

  tags          = {
    Name        = "${var.app_id}-ecs-tasks-security-group"
  }
}

# Security group for the ECR VPC Endpoint
resource "aws_security_group" "ecr_vpc_endpoint" {
  name = "${var.app_id}-ecr-vpc-endpoint-security-group"
  description = "Allow ECS Tasks to access the ECR Endpoint"
  vpc_id      = aws_vpc.main.id

  # TODO: Is any of this needed?
  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    security_groups = [aws_security_group.ecs_tasks.id]
    #cidr_blocks = ["0.0.0.0/0"]
    # QUESTION: Should this be a security group or CIDR?
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags          = {
    Name        = "${var.app_id}-ecr-vpc-endpoint-security-group"
  }

}