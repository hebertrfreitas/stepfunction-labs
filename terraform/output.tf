output "sns_topic_arn" {
  description = "The ARN of the SNS topic"
  value       = aws_sns_topic.request-to-process-topic.arn
}

output "ecs_cluster_arn"{
    description = "The ARN of the ecs cluster"
    value = aws_ecs_cluster.ecs-cluster.arn
}