module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.vpc_name}-vpc"
  cidr = var.vpc_cidr

  azs             = ["us-east-1a","us-east-1b"]
  private_subnets = [var.private_subnet_cidr1,var.private_subnet_cidr2]
  public_subnets  = [var.public_subnet_cidr1,var.public_subnet_cidr2]

  enable_nat_gateway = false
  enable_vpn_gateway = false
  single_nat_gateway = true
}

module "node-sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "node-sg"
  description = "Allow nodes to communicate with each other"
  vpc_id      = module.vpc.vpc_id
ingress_with_self = [
  {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    description = "Allow nodes to communicate with each other"
    self        = true
  }
]

egress_with_cidr_blocks = [
  {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    description = "Allow all outbound traffic"
    cidr_blocks = "0.0.0.0/0"
  }
]
}

module "eks-additional-sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "eks-additional-sg"
  vpc_id      = module.vpc.vpc_id
  ingress_with_source_security_group_id = [
    {
      description     = "Allow pods running extension API servers on port 443 to receive communication from cluster control plane"
      from_port       = 443
      to_port         = 443
      protocol        = "tcp"
      source_security_group_id = module.node-sg.security_group_id
    },{
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = module.node-sg.security_group_id 
}
]
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = -1
      description = "Allow all outbound traffic"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}