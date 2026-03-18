resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = "true"

  tags = local.vpc_final_tags
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id # vpc association to internet gateway

  tags = local.igw_final_tags
}

 # public subnet
resource "aws_subnet" "public" {
 count = length(var.public_subnet_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr[count.index]
  availability_zone = local.AZ_names[count.index]
  map_public_ip_on_launch = true 
  # to get public address

  tags = merge(
        local.common_tags,
        {
            #roboshop-dev-public-us-east-1a
            Name = "${var.project}-${var.environment}-public-${local.AZ_names[count.index]}"
        },
           var.public_subnet_tags
  )
} 

 # private subnet
resource "aws_subnet" "private" {
 count = length(var.private_subnet_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidr[count.index]
  availability_zone = local.AZ_names[count.index]

  tags = merge(
        local.common_tags,
        {
            #roboshop-dev-private-us-east-1a
            Name = "${var.project}-${var.environment}-private-${local.AZ_names[count.index]}"
        },
           var.private_subnet_tags
  )
} 

 # database subnet
resource "aws_subnet" "database" {
 count = length(var.database_subnet_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.database_subnet_cidr[count.index]
  availability_zone = local.AZ_names[count.index]

  tags = merge(
        local.common_tags,
        {
            #roboshop-dev-database-us-east-1a
            Name = "${var.project}-${var.environment}-database-${local.AZ_names[count.index]}"
        },
           var.database_subnet_tags
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags =  merge(
        local.common_tags,
        {
            #roboshop-public
            Name = "${var.project}-${var.environment}-public-${local.AZ_names[count.index]}"
        },
           var.public_route_subnet_tags
  )
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags =  merge(
        local.common_tags,
        {
            #roboshop-private
            Name = "${var.project}-${var.environment}-private-${local.AZ_names[count.index]}"
        },
           var.private_route_subnet_tags
  )
}

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  tags =  merge(
        local.common_tags,
        {
            #roboshop-database
            Name = "${var.project}-${var.environment}-database-${local.AZ_names[count.index]}"
        },
           var.database_route_subnet_tags
  )
}