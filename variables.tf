# variable "region" {}
# variable "vpc_name" {}
# variable "public_subnet_cidr" {}
# variable "private_subnet_cidr" {}
# variable "vpc_cidr" {}
locals {
  region      = "us-east-1"
  vpc_name    = "Simetrik"
}

variable "vpc_cidr" {
  type    = string
  default = "10.20.0.0/16"
}
variable "vpc_name" {
  type    = string
  default = "simetrik"
}
variable "public_subnet_cidr1" {
  type    = string
  default = "10.20.1.0/24"
}
variable "public_subnet_cidr2" {
  type    = string
  default = "10.20.2.0/24"
}
variable "private_subnet_cidr1" {
  type    = string
  default = "10.20.3.0/24"
}
variable "private_subnet_cidr2" {
  type    = string
  default = "10.20.4.0/24"
}