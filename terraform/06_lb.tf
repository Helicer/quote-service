

resource "aws_alb" "main" {
  name            = "${var.env_id}-load-balancer"
  subnets         = aws_subnet.private.*.id
  security_groups = [aws_security_group.main.id]
}

resource "aws_alb_target_group" "app" {
  name        = "${var.env_id}-target-group"
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

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "front_end" {
  load_balancer_arn = aws_alb.main.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.app.id
    type             = "forward"
  }
}


# Attach to instance
# https://www.terraform.io/docs/providers/aws/r/lb_target_group_attachment.html