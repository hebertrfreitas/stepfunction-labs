#!/bin/bash

# Create SNS topic
TOPIC_ARN=$(awslocal sns create-topic --name input-topic --query 'TopicArn' --output text)

# Create an SQS queue called input-queue
QUEUE_URL=$(awslocal sqs create-queue --queue-name input-queue --query 'QueueUrl' --output text)

# Get the ARN of the SQS queue
QUEUE_ARN=$(awslocal sqs get-queue-attributes --queue-url "$QUEUE_URL" --attribute-name QueueArn --query 'Attributes.QueueArn' --output text)

# Subscribe the SQS queue to the SNS topic
awslocal sns subscribe --topic-arn "$TOPIC_ARN" \
--protocol sqs --notification-endpoint "$QUEUE_ARN" \
 --attributes '{"RawMessageDelivery":"true", "FilterPolicy":"{\"event_type\": [\"type_a\"]}"}'

#List topics
awslocal sns list-topics

# List the queues to verify
awslocal sqs list-queues
