#############################
# NETWORK
#############################


# Fetch current Availability Zones in the current region
data "aws_availability_zones" "available" {
}


#-----------------------------
# VPCs
#-----------------------------

# Main VPC used by the App
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  # TODO: Enable Private DNS resolution to support VPC Endpoints that require it

  tags          = {
    Name        = "${var.app_id}-vpc"
  }

}


#-----------------------------
# VPC Subnets
#-----------------------------

# Create PRIVATE subnets, one for each availability zone
resource "aws_subnet" "private" {
  count             = var.az_count
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id            = aws_vpc.main.id

  tags          = {
    Name        = "${var.app_id}-private-subnet-az${count.index}"
  }
}



# Create PUBLIC subnets, for each availability zone
resource "aws_subnet" "public" {
  count                   = var.az_count
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, var.az_count + count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.main.id

  # This creates the subnet as PUBLIC
  map_public_ip_on_launch = true # Allows it to access internet

  tags          = {
    Name        = "${var.app_id}-public-subnet-az${count.index}"
  }
}




#-----------------------------
# INTERNET CONNECTIVITY
#-----------------------------


# Creates Internet Gateway for the VPC
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.app_id}-internet-gateway"
  }
}



# Elastic IPs (used by Internet Gateway) for each AZ
resource "aws_eip" "internet_gateway_eip" {
  count      = var.az_count
  vpc        = true
  depends_on = [aws_internet_gateway.gw]

  tags = {
    Name        = "${var.app_id}-igw-eip-az${count.index}"
  }
}


# Create a route table for the PRIVATE subnets
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

//  route {
//    cidr_block     = "0.0.0.0/0"
//    nat_gateway_id = element(aws_nat_gateway.gw.*.id, count.index)
//  }

  tags = {
    Name        = "${var.app_id}-private-route-table"
   // Name        = "${var.app_id}-private-route-table-az${count.index}"
  }
}

# Explicitly associate the newly created ROUTE TABLE to each of the PRIVATE SUBNETS
# (so they don't default to the main route table)
resource "aws_route_table_association" "private" {
  count          = var.az_count
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private.id
}



#-----------------------------
# VPC Endpoints
#-----------------------------
# Allows ECS Tasks on private VPCs to access services such
# as ECR, S3, and CloudWatch logs
# Examples: https://github.com/terraform-aws-modules/terraform-aws-vpc/blob/master/vpc-endpoints.tf#L342


# S3 VPC ENDPOINT
#-----------------------------
# - Purpose: Allow Fargate tasks on private subnets to access S3 buckets where container images are hosted
# - Note: Type of endpoint is "gateway"
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.${var.aws_region}.s3"

  tags = {
    Name        = "${var.app_id}-endpoint-s3"
  }
}

# Associate a route from the PRIVATE subnet ROUTE TABLE to the S3 Endpoint
resource "aws_vpc_endpoint_route_table_association" "s3" {
  route_table_id = aws_route_table.private.id
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}



# ECR VPC ENDPOINT
#-----------------------------
# - Purpose: Allow Fargate tasks on private subnets to access the ECR
# - Note: Endpoint type is "interface"
# - Note: No route association is necessary
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

  tags = {
    Name        = "${var.app_id}-endpoint-ecr"
  }
}



# LOGS VPC ENDPOINT (type "interface")
#-----------------------------
# - Purpose: Connect to Cloudwatch
# TODO: Logs VPC Endpoint

### ERROR
# FIXME: CannotPullContainerError: Error response from daemon: Get https://783032674095.dkr.ecr.us-east-1.amazonaws.com/v2/: Unable to connect