variable "vpc_id" {
    type = string
}

variable "wordpress_subnet" {
    type = string
}

variable "rds_subnet" {
    type = list
}

variable "rds_cidr" {
    type = list
}