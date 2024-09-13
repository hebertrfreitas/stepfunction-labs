#!/bin/bash

# Define the SNS topic ARN
TOPIC_ARN="arn:aws:sns:us-east-1:000000000000:input-topic"

# Read the message body from the input.json file
MESSAGE_BODY=$(jq -c . input.json)

CONTAINER_NAME="localstack"

# Send the message to the SNS topic with the message attribute 'event_type'
docker exec -it $CONTAINER_NAME awslocal sns publish \
  --topic-arn "$TOPIC_ARN" \
  --message "$MESSAGE_BODY" \
  --message-attributes '{"event_type": {"DataType": "String", "StringValue": "type_a"}}'

echo "Message sent to SNS topic $TOPIC_ARN with event_type=type_a"