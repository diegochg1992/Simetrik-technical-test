output "vpc_id" {
  value       = module.vpc.vpc_id
}

output "node_sg_id" {
  value       = module.node-sg.security_group_id
}

output "eks_additional_sg" {
  value       = module.eks-additional-sg.security_group_id
}
# output "public_subnet_id" {
#   value = aws_subnet.public.id
# }

output "private_subnets" {
  value       = module.vpc.private_subnets
}