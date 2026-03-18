variable "project" {
    type = string
}

variable "environment" {
    type = string
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16" # Use a string here
}
variable "vpc_tags" {
    type = map
    default = {}
}

variable "igw_tags" {
    type = map 
    default = {}
}

variable "public_subnet_cidr" {
    type =list
    default = ["10.0.1.0/24" , "10.0.2.0/24"]
}

variable "public_subnet_tags" {
    type = map
    default = {}
}

variable "private_subnet_cidr" {
    type =list
    default = ["10.0.11.0/24" , "10.0.12.0/24"]
}

variable "private_subnet_tags" {
    type = map
    default = {}
}

variable "database_subnet_cidr" {
    type =list
    default = ["10.0.21.0/24" , "10.0.22.0/24"]
}

variable "database_subnet_tags" {
    type = map
    default = {}
}

 variable "var.public_route_subnet_tags" {
    type = map
    default = {}
 }

 variable "var.private_route_subnet_tags" {
    type = map
    default = {}
 }

 variable "var.database_route_subnet_tags" {
    type = map
    default = {}
 }