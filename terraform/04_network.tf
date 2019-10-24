
# Fetch AZs in the current region
data "aws_availability_zones" "available" {
}

# Main VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

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
    Name        = "${var.app_id}-private-subnet"
  }
}



# PUBLIC subnets, for each availability zone
resource "aws_subnet" "public" {
  count                   = var.az_count
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, var.az_count + count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true

  tags          = {
    Name        = "${var.app_id}-public-subnet"
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
    Name        = "${var.app_id}-eip"
  }
}

# NAT gateway for PUBLIC subnet
resource "aws_nat_gateway" "gw" {
  count         = var.az_count
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  allocation_id = element(aws_eip.gw.*.id, count.index)

  tags = {
    Name        = "${var.app_id}-nat-gateway"
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
    Name        = "${var.app_id}-private-route-table"
  }
}











