resource "aws_sqs_queue" "input_queue" {
  name                       = var.queue_name
  receive_wait_time_seconds  = 20
  message_retention_seconds  = 43200
  visibility_timeout_seconds = 900
}