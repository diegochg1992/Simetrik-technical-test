terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
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
}


terraform {
  backend "s3" {
    bucket         = local.bkttfstatename
    key            = "terraform.tfstate"
    region         = "us-east-1"
  }
}