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
  count = lenght(var.public_subnet_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr[count.index]
  aws_availability_zones = local.AZ_names[count.index]
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