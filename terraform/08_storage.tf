#############################
# STORAGE
#############################

data "aws_elb_service_account" "main" {}

# See: https://stackoverflow.com/questions/56751080/terraform-setting-up-logging-from-aws-loadbalancer-to-s3-bucket

# Creating policy on S3, for lb to write
resource "aws_s3_bucket_policy" "lb-bucket-policy" {
  bucket = aws_s3_bucket.alb-logs.id

  policy = <<POLICY
{
  "Id": "ALB-Logs-Policy",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "testStmt1561031516716",
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.alb-logs.bucket}/alb-logs/*",
      "Principal": {
        "AWS": [
           "${data.aws_elb_service_account.main.arn}"
        ]
      }
    }
  ]
}
POLICY
}


resource "aws_s3_bucket" "alb-logs" {
  bucket = "quote-service-alb"
  acl    = "private"
  force_destroy = true

  tags = {
    Name        = "${var.app_id}-S3-ALB"
  }
}

# ERRORS
