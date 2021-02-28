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

module "launch_template" {
  source = "./launch_template"
}

module "load_balancers" {
  source = "./load_balancers"
  public_subnet_id = module.vpc.public_subnet_id
  webapp_http_inbound_sg_id = module.vpc.webapp_http_inbound_sg_id
}

module "autoscaling_groups" {
  source = "./autoscaling_groups"
  public_subnet_id = module.vpc.public_subnet_id
  webapp_lt_id = module.launch_template.webapp_lt_id
  webapp_lt_name = module.launch_template.webapp_lt_name
  webapp_elb_name = module.load_balancers.webapp_elb_name
}
