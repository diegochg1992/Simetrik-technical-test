terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.0"
}

provider "aws" {
  region = local.region
}

module "networking" {
  source              = "./modules/networking"
  region              = local.region
  vpc_name            = local.vpc_name
  private_subnets  = [var.private_subnet_cidr1,var.private_subnet_cidr2]
  public_subnets  = [var.public_subnet_cidr1,var.public_subnet_cidr2]
  vpc_cidr            = var.vpc_cidr  
}

module "eks" {
  source              = "./modules/eks"
  region              = local.region
  vpc_id = module.networking.vpc_id
  private_subnet_id1 = module.networking.private_subnets[0]
  private_subnet_id2 = module.networking.private_subnets[1]
  eks_additional_sg = module.networking.eks_additional_sg
  node_sg = module.networking.node_sg_id
}

# data "terraform_remote_state" "networking" {
#   backend = "s3"
#   config = {
#     bucket = "simetrik-bkt-tf-state"
#     key    = "terraform.tfstate"
#     region = "us-east-1"
#   }
# }



terraform {
  backend "s3" {
    bucket         = "simetrik-bkt-tf-state"
    key            = "terraform.tfstate"
    region         = "us-east-1"                                                                                                                                                                                                                                                                                                                                                       
  }
}

