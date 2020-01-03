#############################
# LOGS
#############################

# Set up CloudWatch group and log stream and retain logs for 30 days
resource "aws_cloudwatch_log_group" "log_group" {
  name = "${var.app_id}-log-group"
  retention_in_days = 30

  tags = {
    Name = "${var.app_id}-log-group"
  }
}
