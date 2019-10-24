

# ALB Security Group: Edit to restrict access to the application
resource "aws_security_group" "main" {
  name        = "${var.env_id}-security-group"
  description = "Controls access to application"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol    = "tcp"
    from_port   = var.app_port
    to_port     = var.app_port
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags          = {
    Name        = "${var.env_id}-security-group"
  }
}

