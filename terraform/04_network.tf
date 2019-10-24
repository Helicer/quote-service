
# Fetch AZs in the current region
data "aws_availability_zones" "available" {
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags          = {
    Name        = "${var.env_id}-vpc"
  }

}

# Create var.az_count private subnets, each in a different AZ
resource "aws_subnet" "private" {
  count             = var.az_count
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id            = aws_vpc.main.id
  map_public_ip_on_launch = "false" # needed?

  tags          = {
    Name        = "${var.env_id}-subnet"
  }

}


# Internet Gateway for the public subnet
#resource "aws_internet_gateway" "gw" {
#  vpc_id = aws_vpc.main.id
#
#  tags          = {
#    Name        = "${var.env_id}-gateway"
#  }
#
#}

#---------------------
# TESTING OUT GIVING EGRESS INTERNET ACCESS to Task
#---------------------


# Internet gateway for the public subnet
resource "aws_internet_gateway" "ig" {
  vpc_id = "${aws_vpc.main.id}"
  tags = {
    Name        = "${var.env_id}-gateway"
  }
}

# Elastic IP for NAT 
resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = ["aws_internet_gateway.ig"]

  tags = {
    Name        = "${var.env_id}-eip"  
  }


}

# NAT
resource "aws_nat_gateway" "nat" {
  allocation_id = "${aws_eip.nat_eip.id}"
  subnet_id     = "${element(aws_subnet.private.*.id, 0)}"
  depends_on    = ["aws_internet_gateway.ig"]
  
  tags = {
    #Name        = "${var.env_id}-${element(var.az_count, count.index)}-nat"
    Name        = "${var.env_id}-nat"
  }
}



# Routing table for private subnet
resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name        = "${var.env_id}-private-route-table"  
  }
}


resource "aws_route" "private_nat_gateway" {
  route_table_id         = "${aws_route_table.private.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.nat.id}"
}

resource "aws_route_table_association" "private" {
  count           = var.az_count
  subnet_id       = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id  = "${aws_route_table.private.id}"
}










