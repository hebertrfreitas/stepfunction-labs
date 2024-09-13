resource "aws_sqs_queue" "input_queue" {
  name                       = var.queue_name
  receive_wait_time_seconds  = 20
  message_retention_seconds  = 43200
  visibility_timeout_seconds = 900
}

#Allow sns delivery messages to sqs queue
resource "aws_sqs_queue_policy" "sqs_policy" {
  queue_url = aws_sqs_queue.input_queue.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "sns.amazonaws.com"
        }
        Action = "sqs:SendMessage"
        Resource = aws_sqs_queue.input_queue.arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_sns_topic.input_topic.arn
          }
        }
      }
    ]
  })
}


resource "aws_sns_topic_subscription" "sqs_subscription" {
  topic_arn = aws_sns_topic.input_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.input_queue.arn

  # Enable raw message delivery
  raw_message_delivery = true

  # Subscription filter policy
  filter_policy = jsonencode({
    event_type = ["type_a"]
  })
}