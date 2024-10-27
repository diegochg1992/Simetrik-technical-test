variable "region" {
  type    = string
}
variable "vpc_cidr" {
  type    = string
  default = "10.20.0.0/16"
}
variable "vpc_name" {
  type    = string
  default = "simetrik"
}
variable "public_subnet_cidr" {
  type    = string
  default = "10.20.1.0/24"
}
variable "private_subnet_cidr" {
  type    = string
  default = "10.20.2.0/24"
}