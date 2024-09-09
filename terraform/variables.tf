variable "region" {
  description = "aws region"
  default     = "us-east-1"
}

variable "subnet_ids" {
  description = "The subnet ID for the ECS service"
}

variable "security_group_ids" {
  description = "The security group ID for the ECS service"
}

variable "deploy_ecs_tasks" {
  description = "If true, try to deploy ecs tasks"
  type        = bool
  default     = false
}

variable "queue_name" {
  description = "SQS input queue name"
  type        = string
  default     = "input-queue"
}