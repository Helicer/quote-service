
#-----------------------------
# VPC Endpoints
#-----------------------------
# Allows ECS Tasks on private VPCs to access services such
# as ECR, S3, and CloudWatch logs
# Examples: https://github.com/terraform-aws-modules/terraform-aws-vpc/blob/master/vpc-endpoints.tf#L342
#-----------------------------


# S3 VPC ENDPOINT
#-----------------------------
# - Purpose: Allow Fargate tasks on private subnets to access S3 buckets where container images are hosted
# - Note: Type of endpoint is "gateway"
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.${var.aws_region}.s3"

  tags = {
    Name        = "${var.app_id}-s3-vpc-endpoint"
  }
}

# Associate a route from the PRIVATE subnet ROUTE TABLE to the S3 Endpoint
resource "aws_vpc_endpoint_route_table_association" "s3" {
  route_table_id = aws_route_table.private.id
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}




# ECR VPC ENDPOINT
#-----------------------------
# - Purpose: Allow Fargate tasks on private subnets to access ECR
# - Note: Endpoint type is "interface"
resource "aws_vpc_endpoint" "ecr" {
  service_name = "com.amazonaws.${var.aws_region}.ecr.dkr" # TODO: Add this to variables
  vpc_id = aws_vpc.main.id
  vpc_endpoint_type = "Interface"

  # Private DNS is suggested
  # See: https://docs.aws.amazon.com/AmazonECR/latest/userguide/vpc-endpoints.html
  private_dns_enabled = true

  # Needs a security group permitting Ingress :443 from the Private Subnet
  security_group_ids = [
    "${aws_security_group.ecr_vpc_endpoint.id}",
  ]

  # TODO: Factor into variable
  subnet_ids = [
    "${aws_subnet.private.0.id}",
    "${aws_subnet.private.1.id}",
    "${aws_subnet.private.2.id}",
  ]

  tags = {
    Name        = "${var.app_id}-ecr-vpc-endpoint"
  }
}

# LOGS VPC ENDPOINT
#-----------------------------
# - Purpose: Allow Fargate tasks on private subnets to access ECR
# - Note: Endpoint type is "interface"
resource "aws_vpc_endpoint" "logs" {
  service_name = "com.amazonaws.${var.aws_region}.logs" # TODO: Add this to variables
  vpc_id = aws_vpc.main.id
  vpc_endpoint_type = "Interface"

  # Private DNS is suggested
  # See: https://docs.aws.amazon.com/AmazonECR/latest/userguide/vpc-endpoints.html
  private_dns_enabled = true

  # Needs a security group permitting Ingress :443 from the Private Subnet
  security_group_ids = [
    "${aws_security_group.ecr_vpc_endpoint.id}",
  ]

  # TODO: Factor into variable
  subnet_ids = [
    "${aws_subnet.private.0.id}",
    "${aws_subnet.private.1.id}",
    "${aws_subnet.private.2.id}",
  ]

  tags = {
    Name        = "${var.app_id}-logs-vpc-endpoint"
  }
}

