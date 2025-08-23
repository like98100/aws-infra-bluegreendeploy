variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository (owner/repo)"
  type        = string
}

variable "github_branch" {
  description = "GitHub branch"
  type        = string
}

variable "github_connection_arn" {
  description = "AWS CodeStar Connections ARN for GitHub App"
  type        = string
}

variable "github_token_secret" {
  description = "AWS Secrets Manager secret name containing GitHub token"
  type        = string
}

variable "ecr_repository_name" {
  description = "ECR repository name"
  type        = string
}

variable "ecr_repository_uri" {
  description = "ECR repository URI"
  type        = string
}

variable "ecs_cluster_name" {
  description = "ECS cluster name"
  type        = string
}

variable "ecs_service_name" {
  description = "ECS service name"
  type        = string
}

variable "alb_listener_arn" {
  description = "ALB listener ARN for Blue/Green deployment"
  type        = string
}

variable "alb_test_listener_arn" {
  description = "ALB test listener ARN for Blue/Green deployment"
  type        = string
}

variable "target_group_blue_name" {
  description = "Blue target group name"
  type        = string
}

variable "target_group_green_name" {
  description = "Green target group name"
  type        = string
}

variable "account_id" {
  description = "AWS account ID"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}