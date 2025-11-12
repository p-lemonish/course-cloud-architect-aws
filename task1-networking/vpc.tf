resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = merge(local.common_tags, {
    Name = "chatroom-vpc-task1"
  })
}

resource "aws_subnet" "public_az1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidrs[0]
  availability_zone = var.availability_zones[0]

  tags = merge(local.common_tags, {
    Name = "chatroom-subnet-public-az1"
    Tier = "Public"
  })
}

resource "aws_subnet" "public_az2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidrs[1]
  availability_zone = var.availability_zones[1]

  tags = merge(local.common_tags, {
    Name = "chatroom-subnet-public-az2"
    Tier = "Public"
  })
}

resource "aws_subnet" "private_az1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[0]
  availability_zone = var.availability_zones[0]

  tags = merge(local.common_tags, {
    Name = "chatroom-subnet-private-az1"
    Tier = "Private"
  })
}

resource "aws_subnet" "private_az2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[1]
  availability_zone = var.availability_zones[1]

  tags = merge(local.common_tags, {
    Name = "chatroom-subnet-private-az2"
    Tier = "Private"
  })
}
