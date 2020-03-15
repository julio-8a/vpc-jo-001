# Terraform backend configuration for remote state
terraform {
  backend "s3" {
    bucket       = "tf-remotestate-jo-20200315"
    key          = "gobal/vpc/terraform.tfstate"
    region       = "us-east-2"

    dynamodb_table = "tf-udemy-jo-state-locks"
    encrypt      = true
  }
}


# Internet VPC
resource "aws_vpc" "jo-001" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  tags = {
      Name = "jo-001"
  }
}

# Subnets
resource "aws_subnet" "jo-001-public-1" {
  vpc_id                  = aws_vpc.jo-001.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-2a"

  tags = {
      Name = "jo-001-main-public-1"
  }
}

resource "aws_subnet" "jo-001-public-2" {
  vpc_id                  = aws_vpc.jo-001.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-2b"

  tags = {
      Name = "jo-001-main-public-2"
  }
}

resource "aws_subnet" "jo-001-public-3" {
  vpc_id                  = aws_vpc.jo-001.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-2c"

  tags = {
      Name = "jo-001-main-public-3"
  }
}

resource "aws_subnet" "jo-001-private-1" {
  vpc_id                  = aws_vpc.jo-001.id
  cidr_block              = "10.0.10.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-2a"

  tags = {
      Name = "jo-001-main-private-1"
  }
}

resource "aws_subnet" "jo-001-private-2" {
  vpc_id                  = aws_vpc.jo-001.id
  cidr_block              = "10.0.11.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-2b"

  tags = {
      Name = "jo-001-main-private-2"
  }
}

resource "aws_subnet" "jo-001-private-3" {
  vpc_id                  = aws_vpc.jo-001.id
  cidr_block              = "10.0.12.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-2c"

  tags = {
      Name = "jo-001-main-private-3"
  }
}

# Internet GW
resource "aws_internet_gateway" "jo-001-gw" {
  vpc_id = aws_vpc.jo-001.id

  tags = {
      Name = "jo-001-gw"
  }
}

# Routing tables
resource "aws_route_table" "jo-001-public" {
  vpc_id = aws_vpc.jo-001.id
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.jo-001-gw.id
  }

  tags = {
      Name = "jo-001-public-1"
  }
}

# route associations for public subnets
resource "aws_route_table_association" "jo-001-public-1-a" {
  subnet_id      = aws_subnet.jo-001-public-1.id
  route_table_id = aws_route_table.jo-001-public.id
}

resource "aws_route_table_association" "jo-001-public-2-a" {
  subnet_id      = aws_subnet.jo-001-public-2.id
  route_table_id = aws_route_table.jo-001-public.id
}

resource "aws_route_table_association" "jo-001-public-3-a" {
  subnet_id      = aws_subnet.jo-001-public-3.id
  route_table_id = aws_route_table.jo-001-public.id
}