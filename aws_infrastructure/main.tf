terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.65.0"
    }
  }
  backend "remote" {
    organization = "<YOUR TFC/E ORG>"
    workspaces {
      name = "aws-infrastructure"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_availability_zones" "available" {}

module "vpc" {
  source               = "terraform-aws-modules/vpc/aws"
  version              = "3.11.0"
  cidr                 = var.aws_vpc_cidr
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["10.0.0.0/25","10.0.0.128/25"]
  public_subnets       = ["10.0.1.0/25","10.0.1.128/25"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
}

module "aws" {
  depends_on = [
    module.vpc
  ]
  source              = "./aws"
  tag                 = var.unique_name
  pub_key             = var.pub_key
  priv_key            = var.priv_key
  aws_vpc_id          = module.vpc.vpc_id
  aws_public_subnets  = module.vpc.public_subnets
  aws_private_subnets = module.vpc.private_subnets
  aws_ami_owner       = var.aws_ami_owner
}