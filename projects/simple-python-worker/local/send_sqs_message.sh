#!/bin/bash

# Define the message to send
MESSAGE_BODY=$(jq -c . input.json)


# Define the queue name
QUEUE_NAME="input-queue"

# Define the Docker container name
CONTAINER_NAME="localstack"

# Send the message to the SQS queue using docker exec and awslocal
docker exec -it $CONTAINER_NAME awslocal sqs send-message --queue-url http://localhost:4566/000000000000/$QUEUE_NAME --message-body "$MESSAGE_BODY"

# Check if the message was sent successfully
if [ $? -eq 0 ]; then
  echo "Message sent successfully to $QUEUE_NAME."
else
  echo "Failed to send message to $QUEUE_NAME."
fi