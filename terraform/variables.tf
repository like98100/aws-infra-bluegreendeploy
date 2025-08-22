variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-2"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "like98100-deploy"
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.10.0.0/16"
}

variable "public_subnets" {
  description = "Public subnet CIDR blocks"
  type        = list(string)
  default     = ["10.10.1.0/24", "10.10.3.0/24"]
}

variable "private_subnets" {
  description = "Private subnet CIDR blocks"
  type        = list(string)
  default     = ["10.10.2.0/24", "10.10.4.0/24"]
}

variable "github_repo" {
  description = "GitHub repository name (owner/repo)"
  type        = string
  default     = "like98100/black-friday-deploy-test"
}

variable "github_branch" {
  description = "GitHub branch to track"
  type        = string
  default     = "main"
}

variable "github_token_secret" {
  description = "AWS Secrets Manager secret name containing GitHub token"
  type        = string
  default     = "github-token"
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    Project     = "deploy-test"
    Environment = "dev"
    ManagedBy   = "terraform"
    Owner       = "like98100"
  }
}