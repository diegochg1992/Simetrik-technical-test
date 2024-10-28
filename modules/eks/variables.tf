variable "region" {
  type    = string
  default = "us-east-1"
}
variable "eksclustername" {
  type    = string
  default = "eks-simetrik"
}
variable "private_subnet_id1" {
  type    = string
}
variable "private_subnet_id2" {
  type    = string
}
variable "vpc_id" {
  type    = string
}
variable "eks_additional_sg" {
  type    = string
}
variable "node_sg" {
  type    = string
}