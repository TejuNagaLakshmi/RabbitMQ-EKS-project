variable "region" {
  type    = string
  default = "ca-central-1"
}

variable "stack_name" {
  type    = string
  default = "my-eks-vpc"
}

variable "vpc_cidr" {
  type    = string
  default = "192.168.0.0/16"
}

variable "public_subnet_01_cidr" {
  type    = string
  default = "192.168.0.0/18"
}

variable "public_subnet_02_cidr" {
  type    = string
  default = "192.168.64.0/18"
}

variable "private_subnet_01_cidr" {
  type    = string
  default = "192.168.128.0/18"
}

variable "private_subnet_02_cidr" {
  type    = string
  default = "192.168.192.0/18"
}
