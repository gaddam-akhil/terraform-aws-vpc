resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = "true"

  tags = local.vpc_final_tags
}

resource "aws_internet_gateway" "main" {
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
            Name = "${var.project}-${var.environment}-public"
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
            Name = "${var.project}-${var.environment}-private"
        },
           var.private_route_subnet_tags
  )
}

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  tags =  merge(
        local.common_tags,
        {
            #roboshop--dev-database
            Name = "${var.project}-${var.environment}-database"
        },
           var.database_route_subnet_tags
  )
}

resource "aws_route" "public" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main.id
 
}

# we are creating elastic ip not associating 
resource "aws_eip" "nat" {
  domain                    = "vpc"

  tags =  merge(
        local.common_tags,
        {
            #roboshop-dev-nat
            Name = "${var.project}-${var.environment}-nat"
        },
           var.eip_tags
  )
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id # we are creating specific in us-east-1

  tags = merge(
        local.common_tags,
        {
            #roboshop-dev-nat
            Name = "${var.project}-${var.environment}"
        },
           var.nat_tags
  )

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.main]
}

resource "aws_route" "private" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
 nat_gateway_id = aws_nat_gateway.main.id
 
}

resource "aws_route" "database" {
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = "0.0.0.0/0"
 nat_gateway_id = aws_nat_gateway.main.id
 
}