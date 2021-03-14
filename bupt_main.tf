terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./vpc"
}

module "compute" {
  source = "./compute"
  public_subnet_id = module.vpc.public_subnet_id
  vpc_id = module.vpc.vpc_id
}

module "ci" {
  source = "./ci"
}
