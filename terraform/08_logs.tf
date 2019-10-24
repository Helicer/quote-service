# Set up CloudWatch group and log stream and retain logs for 30 days
resource "aws_cloudwatch_log_group" "log_group" {
  name              = "ecs/${var.env_id}-log-group"
  retention_in_days = 30

  tags = {
    Name = "${var.env_id}-log-group"
  }
}

resource "aws_cloudwatch_log_stream" "log_stream" {
  name           = "${var.env_id}-log-stream"
  log_group_name = aws_cloudwatch_log_group.log_group.name
}