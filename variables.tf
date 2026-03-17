variable "project" {
    type = string
}

variable "environment" {
    type = string
}

variable "vpc_cidr" {
    type = string 
    default = {}
}

variable "vpc_tags" {
    type = map
    default = {}
}