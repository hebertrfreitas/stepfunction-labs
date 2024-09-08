variable "subnet_ids" {
  description = "The subnet ID for the ECS service"
}

variable "security_group_ids" {
  description = "The security group ID for the ECS service"
}

variable "deploy_ecs_tasks"{
    description = "If true, try to deploy ecs tasks"
    type = bool
    default = false
}