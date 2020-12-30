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
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.app_id}-vpc"
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

  tags = {
    Name = "${var.app_id}-private-subnet-az${count.index}"
  }
}



# Create PUBLIC subnets, for each availability zone
resource "aws_subnet" "public" {
  count             = var.az_count
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, var.az_count + count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id            = aws_vpc.main.id

  # This creates the subnet as PUBLIC
  map_public_ip_on_launch = true # Allows it to access internet

  tags = {
    Name = "${var.app_id}-public-subnet-az${count.index}"
  }
}




#-----------------------------
# INTERNET CONNECTIVITY
#-----------------------------


# Creates Internet Gateway for the VPC
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.app_id}-internet-gateway"
  }
}



# Elastic IPs (used by Internet Gateway) for each AZ
resource "aws_eip" "internet_gateway_eip" {
  count      = var.az_count
  vpc        = true
  depends_on = [aws_internet_gateway.gw]

  tags = {
    Name = "${var.app_id}-igw-eip-az${count.index}"
  }
}


# Create a route table for the PRIVATE subnets
# TODO: Is this route table needed?
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.app_id}-private-route-table"
  }
}

# Explicitly associate the newly created ROUTE TABLE to each of the PRIVATE SUBNETS
# (so they don't default to the main route table)
# TODO: Is this route table association needed?
resource "aws_route_table_association" "private" {
  count          = var.az_count
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private.id
}


# Create a route table for the PUBLIC subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  # Ensures all traffic goes through the internet gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${var.app_id}-public-route-table"
  }
}

# Explicitly associate the newly created ROUTE TABLE to each of the PUBLIC SUBNETS
# (so they don't default to the main route table)
resource "aws_route_table_association" "public" {
  count          = var.az_count
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}