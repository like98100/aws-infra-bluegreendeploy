terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Data sources
data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_caller_identity" "current" {}

# VPC Module
module "vpc" {
  source = "./modules/vpc"
  
  project_name = var.project_name
  environment  = var.environment
  vpc_cidr     = var.vpc_cidr
  
  availability_zones = data.aws_availability_zones.available.names
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  
  tags = var.common_tags
}

# Security Groups Module
module "security_groups" {
  source = "./modules/security"
  
  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.vpc.vpc_id
  
  tags = var.common_tags
}

# ALB Module
module "alb" {
  source = "./modules/alb"
  
  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnet_ids
  security_group_id = module.security_groups.alb_security_group_id
  
  tags = var.common_tags
}

# ECR Module
module "ecr" {
  source = "./modules/ecr"
  
  project_name = var.project_name
  environment  = var.environment
  
  tags = var.common_tags
}

# ECS Module
module "ecs" {
  source = "./modules/ecs"
  
  project_name       = var.project_name
  environment        = var.environment
  vpc_id            = module.vpc.vpc_id
  private_subnets   = module.vpc.private_subnet_ids
  security_group_id = module.security_groups.ecs_security_group_id
  
  target_group_blue_arn  = module.alb.target_group_blue_arn
  target_group_green_arn = module.alb.target_group_green_arn
  
  ecr_repository_url = module.ecr.repository_url
  
  tags = var.common_tags
}

# CodePipeline Module
module "codepipeline" {
  source = "./modules/codepipeline"
  
  project_name = var.project_name
  environment  = var.environment
  
  github_repo           = var.github_repo
  github_branch         = var.github_branch
  github_connection_arn = var.github_connection_arn
  github_token_secret   = var.github_token_secret
  
  ecr_repository_name   = module.ecr.repository_name
  ecr_repository_uri    = module.ecr.repository_url
  
  ecs_cluster_name      = module.ecs.cluster_name
  ecs_service_name      = module.ecs.service_name
  
  alb_listener_arn      = module.alb.listener_arn
  target_group_blue_name  = module.alb.target_group_blue_name
  target_group_green_name = module.alb.target_group_green_name
  
  account_id = data.aws_caller_identity.current.account_id
  region     = var.aws_region
  
  tags = var.common_tags
}