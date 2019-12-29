
# Fetch AZs in the current region
data "aws_availability_zones" "available" {
}

# Main VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  # TODO: Enable Private DNS resolution to support VPC Endpoints that require it

  tags          = {
    Name        = "${var.app_id}-vpc"
  }

}


# PRIVATE subnets, for each availability zone
resource "aws_subnet" "private" {
  count             = var.az_count
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id            = aws_vpc.main.id

  tags          = {
    Name        = "${var.app_id}-private-subnet-az${count.index}"
  }
}



# PUBLIC subnets, for each availability zone
resource "aws_subnet" "public" {
  count                   = var.az_count
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, var.az_count + count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true # Allows it to access internet

  tags          = {
    Name        = "${var.app_id}-public-subnet-az${count.index}"
  }
}

# Internet Gateway (to be used for PUBLIC subnet)
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.app_id}-internet-gateway"
  }
}


# Route the PUBLIC subnet traffic through the Internet Gateway
resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.main.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id

}





# Elastic IP, used by NAT gateway to provide subnets internet connectivity
resource "aws_eip" "gw" {
  count      = var.az_count
  vpc        = true
  depends_on = [aws_internet_gateway.gw]

  tags = {
    Name        = "${var.app_id}-eip-az${count.index}"
  }
}

# NAT gateway for PRIVATE subnet
resource "aws_nat_gateway" "gw" {
  count         = var.az_count
  subnet_id     = element(aws_subnet.private.*.id, count.index)
  allocation_id = element(aws_eip.gw.*.id, count.index)

  tags = {
    Name        = "${var.app_id}-nat-gateway-az${count.index}"
  }
}


# Route table for the PRIVATE subnets,
# Routes non-local traffic through the NAT gateway to the internet
resource "aws_route_table" "private" {
  count  = var.az_count
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.gw.*.id, count.index)
  }

  tags = {
    Name        = "${var.app_id}-private-route-table-az${count.index}"
  }
}

# Explicitly associate the newly created route tables to the private subnets
# (so they don't default to the main route table)
resource "aws_route_table_association" "private" {
  count          = var.az_count
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}

#-----------------------------
# VPC Endpoints
#-----------------------------
# Allows ECS Tasks on private VPCs to access services such
# as ECR, S3, and CloudWatch logs
# Examples: https://github.com/terraform-aws-modules/terraform-aws-vpc/blob/master/vpc-endpoints.tf#L342

# S3 VPC Endpoint (type "gateway")
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.${var.aws_region}.s3" # TODO: Check this

  tags = {
    Name        = "${var.app_id}-endpoint-s3"
  }
}

resource "aws_vpc_endpoint_route_table_association" "s3" {
  count          = var.az_count
  route_table_id = element(aws_route_table.private.*.id, count.index)
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}



# ECR VPC Endpoint (type "interface")

resource "aws_vpc_endpoint" "ecr" {
  service_name = "com.amazonaws.${var.aws_region}.ecr.dkr"
  vpc_id = aws_vpc.main.id
  vpc_endpoint_type = "Interface"
  private_dns_enabled = true

  security_group_ids = [
    "${aws_security_group.vpc_endpoint.id}",
  ]

  tags = {
    Name        = "${var.app_id}-endpoint-ecr"
  }
}



# Logs VPC Endpoint (type "interface")

### ERROR
# FIXME: CannotPullContainerError: Error response from daemon: Get https://783032674095.dkr.ecr.us-east-1.amazonaws.com/v2/: Unable to connect
