variable "region" {
  type    = string
  default = "ca-central-1"
}

variable "availability_zones" {
  type    = list(string)
  default = ["ca-central-1a", "ca-central-1b"]
}

variable "stack_name" {
  type    = string
  default = "my-eks-vpc-new"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_01_cidr" {
  type    = string
  default = "10.0.0.0/18"
}

variable "public_subnet_02_cidr" {
  type    = string
  default = "10.0.64.0/18"
}

variable "private_subnet_01_cidr" {
  type    = string
  default = "10.0.128.0/18"
}

variable "private_subnet_02_cidr" {
  type    = string
  default = "10.0.192.0/18"
}
