terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "ap-northeast-1"
}

# VPC
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
resource "aws_vpc" "dev-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "kodacdev-vpc"
  }
}

# Subnet
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
resource "aws_subnet" "dev-subnet-public-01" {
  cidr_block        = "10.0.0.0/20"
  availability_zone = "ap-northeast-1a"
  vpc_id            = aws_vpc.dev-vpc.id

  tags = {
    Name = "kodacdev-subnet-public-01"
  }
}

resource "aws_subnet" "dev-subnet-public-02" {
  cidr_block        = "10.0.16.0/20"
  availability_zone = "ap-northeast-1c"
  vpc_id            = aws_vpc.dev-vpc.id

  tags = {
    Name = "kodacdev-subnet-public-02"
  }
}

resource "aws_subnet" "dev-subnet-private-01" {
  cidr_block        = "10.0.64.0/20"
  availability_zone = "ap-northeast-1a"
  vpc_id            = aws_vpc.dev-vpc.id

  tags = {
    Name = "kodacdev-subnet-private-01"
  }
}

resource "aws_subnet" "dev-subnet-private-02" {
  cidr_block        = "10.0.80.0/20"
  availability_zone = "ap-northeast-1c"
  vpc_id            = aws_vpc.dev-vpc.id

  tags = {
    Name = "kodacdev-subnet-private-02"
  }
}

# Internet Gateway
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
resource "aws_internet_gateway" "dev-igw" {
  vpc_id = aws_vpc.dev-vpc.id

  tags = {
    Name = "kodacdev-igw"
  }
}

# Elastic IP
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip
resource "aws_eip" "dev-eip-01" {
  vpc = true

  tags = {
    Name = "kodacdev-eip-01"
  }
}

resource "aws_eip" "dev-eip-02" {
  vpc = true

  tags = {
    Name = "kodacdev-eip-02"
  }
}

# NAT Gateway
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway
resource "aws_nat_gateway" "dev-ngw-01" {
  subnet_id     = aws_subnet.dev-subnet-public-01.id
  allocation_id = aws_eip.dev-eip-01.id

  tags = {
    Name = "kodacdev-ngw-01"
  }
}

resource "aws_nat_gateway" "dev-ngw-02" {
  subnet_id     = aws_subnet.dev-subnet-public-02.id
  allocation_id = aws_eip.dev-eip-02.id

  tags = {
    Name = "kdoacdev-ngw-02"
  }
}

# Route Table
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
resource "aws_route_table" "dev-rt-public" {
  vpc_id = aws_vpc.dev-vpc.id

  tags = {
    Name = "kodacdev-rt-public"
  }
}

# Route Table (private)
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
resource "aws_route_table" "dev-rt-private-01" {
  vpc_id = aws_vpc.dev-vpc.id

  tags = {
    Name = "kodacdev-rt-private-01"
  }
}

resource "aws_route_table" "dev-rt-private-02" {
  vpc_id = aws_vpc.dev-vpc.id

  tags = {
    Name = "kodacdev-rt-private-02"
  }
}

# Route
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route
resource "aws_route" "dev-r-public" {
  route_table_id         = aws_route_table.dev-rt-public.id
  gateway_id             = aws_internet_gateway.dev-igw.id
  destination_cidr_block = "0.0.0.0/0"
}

# Route (private)
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route
resource "aws_route" "dev-r-private-01" {
  route_table_id         = aws_route_table.dev-rt-private-01.id
  nat_gateway_id         = aws_nat_gateway.dev-ngw-01.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route" "dev-r-private-02" {
  route_table_id         = aws_route_table.dev-rt-private-02.id
  nat_gateway_id         = aws_nat_gateway.dev-ngw-02.id
  destination_cidr_block = "0.0.0.0/0"
}

# Route Table Association
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
resource "aws_route_table_association" "dev-rta-public-01" {
  route_table_id = aws_route_table.dev-rt-public.id
  subnet_id      = aws_subnet.dev-subnet-public-01.id
}

resource "aws_route_table_association" "dev-rta-public-02" {
  route_table_id = aws_route_table.dev-rt-public.id
  subnet_id      = aws_subnet.dev-subnet-public-02.id
}

# Route Table Association (private)
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
resource "aws_route_table_association" "dev-rta-private-01" {
  route_table_id = aws_route_table.dev-rt-private-01.id
  subnet_id      = aws_subnet.dev-subnet-private-01.id
}

resource "aws_route_table_association" "dev-rta-private-02" {
  route_table_id = aws_route_table.dev-rt-private-02.id
  subnet_id      = aws_subnet.dev-subnet-private-02.id
}

# Security Group (for bastion)
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "dev-sg-bastion" {
  name        = "kodacdev-sg-bastion"
  description = "security group for bastion server"
  vpc_id      = aws_vpc.dev-vpc.id

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "kodacdev-sg-bastion"
  }
}

# RDS
module "dev-db" {
  db-prefix = "dev"
  source    = "./modules/postgres"
  db-subnet-ids = [
    aws_subnet.dev-subnet-private-01.id,
    aws_subnet.dev-subnet-private-02.id
  ]
  postgres-version = "13.7"
  instance-class   = "db.t3.micro"
  database-name    = "dev"
  username         = var.username
  password         = var.password
}
