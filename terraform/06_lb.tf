#############################
# LOAD BALANCERS
#############################

# Public-facing load balancer for application
resource "aws_alb" "main" {
  name            = "${var.app_id}-load-balancer"
  subnets         = aws_subnet.public.*.id
  security_groups = [aws_security_group.lb.id]

  # TODO: Create S3 Bucket in TF and refer to it here
   access_logs {
     bucket  = aws_s3_bucket.alb-logs.id
     enabled = true
     prefix  = "alb-logs"
  }

}


output "alb_domain" {
  value = aws_alb.main.dns_name
}

# ALB Target group
# Note: This is registered by the ECS Service
resource "aws_alb_target_group" "app" {
  name        = "${var.app_id}-target-group"
  port        = var.app_port
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = var.health_check_path
    unhealthy_threshold = "2"
  }
}

# Listener for incoming traffic to the ALB.
# Sends to target group.
resource "aws_alb_listener" "front_end" {
  load_balancer_arn = aws_alb.main.id
  port              = 80 # TODO: Factor into TF variables
  protocol          = "HTTP"

  # TODO: Add HTTPS 443

  default_action {
    target_group_arn = aws_alb_target_group.app.id
    type             = "forward"
  }
}
