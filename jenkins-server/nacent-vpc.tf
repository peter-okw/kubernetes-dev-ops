## Create VPC

resource "aws_vpc" "nacent-vpc" {
  cidr_block = "10.0.0.0/16"
    enable_dns_support = "true" 
    enable_dns_hostnames = "true"
    instance_tenancy = "default"   
    tags = {
        Name = "nacent-vpc" 
    }
}
/*
## Declar Existing VPC
data "aws_vpc" "selected" {
  filter {
    name = "tag:Name"
    values = ["dev-vpc"]
  }
}
*/
## Create Public Subnets
resource "aws_subnet" "nacent-public-subnet-1" {
  vpc_id = aws_vpc.nacent-vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "eu-west-2a"
  tags = {
      Name                                   = "nacent-public-subnet-1"
      "kubernetes.io/role/elb"               = "1"
      "kubernetes.io/cluster/nacent-cluster" = "owned"
  }
}
resource "aws_subnet" "nacent-public-subnet-2" {
  vpc_id = aws_vpc.nacent-vpc.id
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "eu-west-2b"
  tags = {
      Name                                    = "nacent-public-subnet-2"
      "kubernetes.io/role/elb"                = "1"
      "kubernetes.io/cluster/nacent-cluster"  = "owned"
  }
}

resource "aws_subnet" "nacent-public-subnet-3" {
    vpc_id = aws_vpc.nacent-vpc.id
    cidr_block = "10.0.3.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "eu-west-2c"
    tags = {
      Name                                     = "nacent-public-subnet-3"
      "kubernetes.io/role/elb"                 = "1"
      "kubernetes.io/cluster/nacent-cluster"   = "owned"
    }
}

## Create Internet Gatway
resource "aws_internet_gateway" "nacent-ig" {
    vpc_id = aws_vpc.nacent-vpc.id
    tags = {
        Name = "nacent-ig"

    }
}

## Create Custom Route Table
resource "aws_route_table" "nacent-rt" {
    vpc_id = aws_vpc.nacent-vpc.id
    
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.nacent-ig.id
    }
    tags = {
        Name = "nacent-rt"
    }
}

resource "aws_route_table_association" "nacent-rt-public-sbnet-1" {
    subnet_id = "${aws_subnet.nacent-public-subnet-1.id}"
    route_table_id = "${aws_route_table.nacent-rt.id}"
}
resource "aws_route_table_association" "nacent-rt-public-sbnet-2" {
    subnet_id = "${aws_subnet.nacent-public-subnet-2.id}"
    route_table_id = "${aws_route_table.nacent-rt.id}"
}
resource "aws_route_table_association" "nacent-rt-public-sbnet-3" {
    subnet_id = "${aws_subnet.nacent-public-subnet-3.id}"
    route_table_id = "${aws_route_table.nacent-rt.id}"
  
}

## Create Private Subnets
resource "aws_subnet" "nacent-private-subnet-1" {
    vpc_id = aws_vpc.nacent-vpc.id
    cidr_block = "10.0.101.0/24"
    availability_zone = "eu-west-2a"
    tags = {
       Name                                   = "nacent-private-subnet-1"
       "kubernetes.io/role/internal-elb"      = "1"
       "kubernetes.io/cluster/nacent-cluster" = "owned"
    }
}

resource "aws_subnet" "nacent-private-subnet-2" {
    vpc_id = aws_vpc.nacent-vpc.id
    cidr_block = "10.0.102.0/24"
    availability_zone = "eu-west-2b"
    tags = {
       Name                                    = "nacent-private-subnet-2"
       "kubernetes.io/role/internal-elb"       = "1"
       "kubernetes.io/cluster/nacent-cluster"  = "owned"
    }
}

resource "aws_subnet" "nacent-private-subnet-3" {
    vpc_id = aws_vpc.nacent-vpc.id
    cidr_block = "10.0.103.0/24"
    availability_zone = "eu-west-2c"
    tags = {
      Name                                      = "nacent-private-subnet-3"
      "kubernetes.io/role/internal-elb"         = "1"
      "kubernetes.io/cluster/nacent-cluster"    = "owned"
    }
  
}

## Create ElasticIP for NAT Gateway
resource "aws_eip" "nacent-NAT-eip-1" {
}
/*
## Create ElasticIP for NAT Gateway
resource "aws_eip" "nacent-NAT-eip-2" {
}
*/
## Create NAT Gateway
resource "aws_nat_gateway" "nacent-NAT-GW-1" {
    allocation_id = aws_eip.nacent-NAT-eip-1.id
    subnet_id = aws_subnet.nacent-public-subnet-1.id
}
/*
resource "aws_nat_gateway" "nacent-NAT-GW-2" {
    allocation_id = aws_eip.nacent-NAT-eip-2.id
    subnet_id = aws_subnet.nacent-public-subnet-2.id
}
*/
## Creating Route Table for NAT Traffic
resource "aws_route_table" "nacent-rt-1" {
    vpc_id = aws_vpc.nacent-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.nacent-NAT-GW-1.id
    }
    tags = {
        Name = "nacent-rt-1"
    }
}

resource "aws_route_table" "nacent-rt-2" {
    vpc_id = aws_vpc.nacent-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.nacent-NAT-GW-1.id
    }
    tags = {
      Name = "nacent-rt-2"
    }
}

resource "aws_route_table" "nacent-rt-3" {
    vpc_id = aws_vpc.nacent-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.nacent-NAT-GW-1.id
    }
    tags = {
        Name = "nacent-rt-3"
    } 
}
## Create Subnet Associations for NAT Traffic Route Table
resource "aws_route_table_association" "nacent-rt-private-subnet-1" {
    subnet_id = "${aws_subnet.nacent-private-subnet-1.id}"
    route_table_id = "${aws_route_table.nacent-rt-1.id}"
}

resource "aws_route_table_association" "nacent-rt-private-sbnet-2" {
    subnet_id = "${aws_subnet.nacent-private-subnet-2.id}"
    route_table_id = "${aws_route_table.nacent-rt-2.id}"
}

resource "aws_route_table_association" "nacent-rt-private-sbnet-3" {
    subnet_id = "${aws_subnet.nacent-private-subnet-3.id}"
    route_table_id = "${aws_route_table.nacent-rt-3.id}"
}
/*
resource "aws_subnet" "nacent-db-subnet-1" {
    vpc_id = "${aws_vpc.nacent-vpc.id}"
    cidr_block = "10.0.151.0/24"
    availability_zone = "eu-west-2a"
    tags = {
       Name = "nacent-db-subnet-1"
    }
}

resource "aws_subnet" "nacent-db-subnet-2" {
    vpc_id = "${aws_vpc.nacent-vpc.id}"
    cidr_block = "10.0.152.0/24"
    availability_zone = "eu-west-2b"
    tags = {
       Name = "nacent-db-subnet-2"
    }
}

## Creating Route Table for DB Access to NAT Traffic
resource "aws_route_table" "nacent-rt-db" {
    vpc_id = aws_vpc.nacent-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.nacent-NAT-GW-1.id
    }
    tags = {
        Name = "nacent-rt-2"
    }
}

resource "aws_route_table_association" "nacent-rt-db-sbnet-1" {
    subnet_id = "${aws_subnet.nacent-db-subnet-1.id}"
    route_table_id = "${aws_route_table.nacent-rt-db.id}"
}

resource "aws_route_table_association" "nacent-rt-db-sbnet-2" {
    subnet_id = "${aws_subnet.nacent-db-subnet-2.id}"
    route_table_id = "${aws_route_table.nacent-rt-db.id}"
}
*/